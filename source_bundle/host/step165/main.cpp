#include <e32base.h>
#include <e32math.h>
#include <gdi.h>
#include <fbs.h>
#include <w32std.h>
#include "model_data.h"

// Textured multi-model validation build: bottle, barrel, and pine tree.

struct TProjectedPoint
    {
    TPoint iPoint;
    };

static void CalculateModelBounds(const TModelData& aModel, TReal& aCenterX,
                                 TReal& aCenterY, TReal& aCenterZ,
                                 TReal& aScale)
    {
    TInt minX = aModel.vertices[0].x, maxX = minX;
    TInt minY = aModel.vertices[0].y, maxY = minY;
    TInt minZ = aModel.vertices[0].z, maxZ = minZ;
    for (TInt i = 1; i < aModel.vertexCount; ++i)
        {
        const TModelVertex& v = aModel.vertices[i];
        if (v.x < minX) minX = v.x;
        if (v.x > maxX) maxX = v.x;
        if (v.y < minY) minY = v.y;
        if (v.y > maxY) maxY = v.y;
        if (v.z < minZ) minZ = v.z;
        if (v.z > maxZ) maxZ = v.z;
        }
    aCenterX = (minX + maxX) / 512.0;
    aCenterY = (minY + maxY) / 512.0;
    aCenterZ = (minZ + maxZ) / 512.0;
    TReal sx = (maxX - minX) / 256.0;
    TReal sy = (maxY - minY) / 256.0;
    TReal sz = (maxZ - minZ) / 256.0;
    TReal span = sx;
    if (sy > span) span = sy;
    if (sz > span) span = sz;
    if (span < 0.01) span = 1.0;
    aScale = 1.8 / span;
    }

static void ProjectModel(const TModelData& aModel, TProjectedPoint* aOut,
                         TReal aCX, TReal aCY, TReal aCZ, TReal aScale,
                         TInt aWidth, TInt aHeight)
    {
    const TReal focal = (aWidth < aHeight ? aWidth : aHeight) * 1.05;
    for (TInt i = 0; i < aModel.vertexCount; ++i)
        {
        TReal x = (aModel.vertices[i].x / 256.0 - aCX) * aScale;
        TReal y = (aModel.vertices[i].y / 256.0 - aCY) * aScale;
        TReal z = (aModel.vertices[i].z / 256.0 - aCZ) * aScale;
        // A fixed three-quarter view; rotation is intentionally out of scope.
        TReal rx = x * 0.8660254 + z * 0.5;
        TReal rz = -x * 0.5 + z * 0.8660254;
        TReal ry = y * 0.9063078 - rz * 0.4226183;
        TReal rz2 = y * 0.4226183 + rz * 0.9063078;
        TReal depth = rz2 + 3.6;
        if (depth < 0.7) depth = 0.7;
        TReal f = focal / depth;
        aOut[i].iPoint = TPoint(aWidth / 2 + (TInt)(rx * f),
                                aHeight / 2 - (TInt)(ry * f));
        }
    }

static TInt ClampInt(TInt aValue, TInt aMin, TInt aMax)
    {
    if (aValue < aMin) return aMin;
    if (aValue > aMax) return aMax;
    return aValue;
    }

static TUint16 Convert444To565(TUint16 aPixel)
    {
    TInt r = (aPixel >> 8) & 15;
    TInt g = (aPixel >> 4) & 15;
    TInt b = aPixel & 15;
    return (TUint16)(((r << 1 | r >> 3) << 11) |
                     ((g << 2 | g >> 2) << 5) |
                     (b << 1 | b >> 3));
    }

static void RasterTriangle(TUint16* aPixels, TInt aStridePixels,
                           TInt aWidth, TInt aHeight,
                           const TProjectedPoint& p0,
                           const TProjectedPoint& p1,
                           const TProjectedPoint& p2,
                           TReal u0, TReal v0, TReal u1, TReal v1,
                           TReal u2, TReal v2, const TModelData& aModel,
                           TReal aUvMaxU, TReal aUvMaxV)
    {
    TInt minX = ClampInt(Min(Min(p0.iPoint.iX, p1.iPoint.iX), p2.iPoint.iX), 0, aWidth - 1);
    TInt maxX = ClampInt(Max(Max(p0.iPoint.iX, p1.iPoint.iX), p2.iPoint.iX), 0, aWidth - 1);
    TInt minY = ClampInt(Min(Min(p0.iPoint.iY, p1.iPoint.iY), p2.iPoint.iY), 0, aHeight - 1);
    TInt maxY = ClampInt(Max(Max(p0.iPoint.iY, p1.iPoint.iY), p2.iPoint.iY), 0, aHeight - 1);
    TReal x0 = p0.iPoint.iX, y0 = p0.iPoint.iY;
    TReal x1 = p1.iPoint.iX, y1 = p1.iPoint.iY;
    TReal x2 = p2.iPoint.iX, y2 = p2.iPoint.iY;
    TReal denom = (y1-y2)*(x0-x2) + (x2-x1)*(y0-y2);
    if (denom > -0.0001 && denom < 0.0001) return;
    TReal inv = 1.0 / denom;
    for (TInt y = minY; y <= maxY; ++y)
        {
        for (TInt x = minX; x <= maxX; ++x)
            {
            TReal px = x + 0.5, py = y + 0.5;
            TReal w0 = ((y1-y2)*(px-x2) + (x2-x1)*(py-y2)) * inv;
            TReal w1 = ((y2-y0)*(px-x2) + (x0-x2)*(py-y2)) * inv;
            TReal w2 = 1.0 - w0 - w1;
            if (w0 < 0.0 || w1 < 0.0 || w2 < 0.0) continue;
            TReal uu = (w0*u0 + w1*u1 + w2*u2) / aUvMaxU;
            TReal vv = (w0*v0 + w1*v1 + w2*v2) / aUvMaxV;
            TInt tx = ClampInt((TInt)(uu * (aModel.textureWidth - 1)), 0, aModel.textureWidth - 1);
            TInt ty = ClampInt((TInt)(vv * (aModel.textureHeight - 1)), 0, aModel.textureHeight - 1);
            TUint16 source = aModel.texture[ty * aModel.textureWidth + tx];
            aPixels[y * aStridePixels + x] = Convert444To565(source);
            }
        }
    }

static void DrawTexturedModel(CFbsBitmap& aBitmap, const TModelData& aModel,
                              TInt aWidth, TInt aHeight)
    {
    TReal cx=0.0, cy=0.0, cz=0.0, scale=1.0;
    CalculateModelBounds(aModel, cx, cy, cz, scale);
    if (aModel.vertexCount <= 0 || aModel.vertexCount > 2048) return;
    TProjectedPoint* projected = static_cast<TProjectedPoint*>(
        User::Alloc(sizeof(TProjectedPoint) * aModel.vertexCount));
    if (!projected) return;
    ProjectModel(aModel, projected, cx, cy, cz, scale, aWidth, aHeight);

    TReal uvMaxU = 1.0, uvMaxV = 1.0;
    for (TInt i=0; i<aModel.faceCount; ++i)
        {
        const TModelFace& f = aModel.faces[i];
        if (f.u0 > uvMaxU) uvMaxU=f.u0; if (f.u1 > uvMaxU) uvMaxU=f.u1; if (f.u2 > uvMaxU) uvMaxU=f.u2;
        if (f.v0 > uvMaxV) uvMaxV=f.v0; if (f.v1 > uvMaxV) uvMaxV=f.v1; if (f.v2 > uvMaxV) uvMaxV=f.v2;
        }
    aBitmap.LockHeap(ETrue);
    TUint16* pixels = reinterpret_cast<TUint16*>(aBitmap.DataAddress());
    if (!pixels)
        {
        aBitmap.UnlockHeap(ETrue);
        User::Free(projected);
        return;
        }
    TInt stride = CFbsBitmap::ScanLineLength(aWidth, EColor64K) / 2;
    for (TInt y=0; y<aHeight; ++y)
        for (TInt x=0; x<aWidth; ++x)
            pixels[y*stride+x] = 0x1082;
    for (TInt i=0; i<aModel.faceCount; ++i)
        {
        const TModelFace& f = aModel.faces[i];
        if (f.a >= aModel.vertexCount || f.b >= aModel.vertexCount || f.c >= aModel.vertexCount) continue;
        RasterTriangle(pixels, stride, aWidth, aHeight,
            projected[f.a], projected[f.b], projected[f.c],
            f.u0, f.v0, f.u1, f.v1, f.u2, f.v2,
            aModel, uvMaxU, uvMaxV);
        }
    aBitmap.UnlockHeap(ETrue);
    User::Free(projected);
    }

static void DrawWireframe(CWindowGc& aGc, const TModelData& aModel,
                             TInt aWidth, TInt aHeight)
    {
    if (aModel.vertexCount <= 0 || aModel.vertexCount > 2048) return;
    TReal cx=0.0, cy=0.0, cz=0.0, scale=1.0;
    CalculateModelBounds(aModel, cx, cy, cz, scale);
    TProjectedPoint* projected = static_cast<TProjectedPoint*>(
        User::Alloc(sizeof(TProjectedPoint) * aModel.vertexCount));
    if (!projected) return;
    ProjectModel(aModel, projected, cx, cy, cz, scale, aWidth, aHeight);
    aGc.SetPenColor(TRgb(210,220,235));
    for (TInt i=0; i<aModel.faceCount; ++i)
        {
        const TModelFace& f = aModel.faces[i];
        if (f.a < 0 || f.b < 0 || f.c < 0 ||
            f.a >= aModel.vertexCount || f.b >= aModel.vertexCount ||
            f.c >= aModel.vertexCount) continue;
        aGc.DrawLine(projected[f.a].iPoint, projected[f.b].iPoint);
        aGc.DrawLine(projected[f.b].iPoint, projected[f.c].iPoint);
        aGc.DrawLine(projected[f.c].iPoint, projected[f.a].iPoint);
        }
    User::Free(projected);
    }

static TInt RunViewer()
    {
    CTrapCleanup* cleanup = CTrapCleanup::New();
    if (!cleanup) return KErrNoMemory;
    RWsSession session;
    TInt error = session.Connect();
    if (error != KErrNone) { delete cleanup; return error; }
    error = RFbsSession::Connect();
    if (error != KErrNone) { session.Close(); delete cleanup; return error; }
    {
    CWsScreenDevice screen(session);
    error = screen.Construct();
    if (error == KErrNone)
        {
        CWindowGc gc(&screen);
        error = gc.Construct();
        if (error == KErrNone)
            {
            TSize size = screen.SizeInPixels();
            CFbsBitmap bitmap;
            error = bitmap.Create(size, EColor64K);
            if (error == KErrNone)
                {
                RWindowGroup group(session);
                error = group.Construct(1, ETrue);
                if (error == KErrNone)
                    {
                    RWindow window(session);
                    error = window.Construct(group, 2);
                    if (error == KErrNone)
                        {
                        group.SetOrdinalPosition(0);
                        window.SetExtent(TPoint(0,0), size);
                        window.SetBackgroundColor(TRgb(5,9,17));
                        window.SetVisible(ETrue);
                        window.Activate();
                        const TRect full(0,0,size.iWidth,size.iHeight);
                        // Isolation build: render only the barrel to test the second mesh independently.
                        // No model switching, texture access, or dynamic label conversion.
                        window.BeginRedraw(full);
                        gc.Activate(window);
                        gc.Clear(full);
                        gc.SetPenColor(TRgb(210,220,235));
                        DrawWireframe(gc, KModels[1], size.iWidth, size.iHeight);
                        gc.Deactivate();
                        window.EndRedraw();
                        session.Flush();
                        // Keep the process alive long enough to distinguish a renderer
                        // fault from an immediate normal return.
                        User::After(60000000);
                        window.Close();
                        }
                    group.Close();
                    }
                }
            }
        }
    }
    RFbsSession::Disconnect();
    session.Close();
    delete cleanup;
    return error;
    }

int main()
    {
    return RunViewer();
    }
