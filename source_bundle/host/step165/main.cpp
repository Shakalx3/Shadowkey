#include <e32base.h>
#include <e32math.h>
#include <gdi.h>
#include <w32std.h>
#include "model_data.h"

struct TPoint3D
    {
    TReal iX;
    TReal iY;
    TReal iZ;
    };

struct TProjectedPoint
    {
    TPoint iPoint;
    TReal iDepth;
    };

static TReal AbsReal(TReal aValue)
    {
    return aValue < 0.0 ? -aValue : aValue;
    }

static void CalculateModelBounds(TReal& aCenterX, TReal& aCenterY,
                                 TReal& aCenterZ, TReal& aScale)
    {
    TInt minX = KModelVertices[0].x;
    TInt maxX = KModelVertices[0].x;
    TInt minY = KModelVertices[0].y;
    TInt maxY = KModelVertices[0].y;
    TInt minZ = KModelVertices[0].z;
    TInt maxZ = KModelVertices[0].z;
    for (TInt i = 1; i < KModelVertexCount; ++i)
        {
        if (KModelVertices[i].x < minX) minX = KModelVertices[i].x;
        if (KModelVertices[i].x > maxX) maxX = KModelVertices[i].x;
        if (KModelVertices[i].y < minY) minY = KModelVertices[i].y;
        if (KModelVertices[i].y > maxY) maxY = KModelVertices[i].y;
        if (KModelVertices[i].z < minZ) minZ = KModelVertices[i].z;
        if (KModelVertices[i].z > maxZ) maxZ = KModelVertices[i].z;
        }
    aCenterX = (minX + maxX) / 512.0;
    aCenterY = (minY + maxY) / 512.0;
    aCenterZ = (minZ + maxZ) / 512.0;
    TReal spanX = (maxX - minX) / 256.0;
    TReal spanY = (maxY - minY) / 256.0;
    TReal spanZ = (maxZ - minZ) / 256.0;
    TReal span = spanX;
    if (spanY > span) span = spanY;
    if (spanZ > span) span = spanZ;
    if (span < 0.01) span = 1.0;
    aScale = 1.7 / span;
    }

static void ProjectModel(TProjectedPoint* aOutput, TReal aAngleY,
                         TReal aAngleX, TReal aCenterX, TReal aCenterY,
                         TReal aCenterZ, TReal aModelScale,
                         TInt aScreenWidth, TInt aScreenHeight)
    {
    TReal sinY = 0.0, cosY = 1.0, sinX = 0.0, cosX = 1.0;
    Math::Sin(sinY, aAngleY);
    Math::Cos(cosY, aAngleY);
    Math::Sin(sinX, aAngleX);
    Math::Cos(cosX, aAngleX);
    TReal focal = (aScreenHeight < aScreenWidth ? aScreenHeight : aScreenWidth) * 0.92;
    TReal screenX = aScreenWidth / 2.0;
    TReal screenY = aScreenHeight / 2.0;

    for (TInt i = 0; i < KModelVertexCount; ++i)
        {
        TReal x = (KModelVertices[i].x / 256.0 - aCenterX) * aModelScale;
        TReal y = (KModelVertices[i].y / 256.0 - aCenterY) * aModelScale;
        TReal z = (KModelVertices[i].z / 256.0 - aCenterZ) * aModelScale;

        TReal rx = x * cosY + z * sinY;
        TReal rz = -x * sinY + z * cosY;
        TReal ry = y * cosX - rz * sinX;
        TReal rz2 = y * sinX + rz * cosX;
        TReal cameraZ = rz2 + 3.4;
        if (cameraZ < 0.6) cameraZ = 0.6;
        TReal factor = focal / cameraZ;
        aOutput[i].iPoint = TPoint((TInt)(screenX + rx * factor),
                                   (TInt)(screenY - ry * factor));
        aOutput[i].iDepth = cameraZ;
        }
    }

static void DrawModel(CWindowGc& aGc, const TProjectedPoint* aProjected)
    {
    for (TInt i = 0; i < KModelFaceCount; ++i)
        {
        const TModelFace& face = KModelFaces[i];
        const TPoint& p0 = aProjected[face.a].iPoint;
        const TPoint& p1 = aProjected[face.b].iPoint;
        const TPoint& p2 = aProjected[face.c].iPoint;

        TReal depth = (aProjected[face.a].iDepth +
                       aProjected[face.b].iDepth +
                       aProjected[face.c].iDepth) / 3.0;
        TInt shade = 220 - (TInt)(depth * 22.0);
        if (shade < 70) shade = 70;
        if (shade > 210) shade = 210;
        aGc.SetPenColor(TRgb(25, shade, 125 + shade / 3));
        aGc.DrawLine(p0, p1);
        aGc.DrawLine(p1, p2);
        aGc.DrawLine(p2, p0);
        }
    }

static TInt RunViewer()
    {
    CTrapCleanup* cleanup = CTrapCleanup::New();
    if (!cleanup) return KErrNoMemory;

    RWsSession session;
    TInt error = session.Connect();
    if (error != KErrNone)
        {
        delete cleanup;
        return error;
        }

    {
    CWsScreenDevice screen(session);
    error = screen.Construct();
    if (error == KErrNone)
        {
        CWindowGc gc(&screen);
        error = gc.Construct();
        if (error == KErrNone)
            {
            const TSize size = screen.SizeInPixels();
            RWindowGroup group(session);
            error = group.Construct(1, ETrue);
            if (error == KErrNone)
                {
                RWindow window(session);
                error = window.Construct(group, 2);
                if (error == KErrNone)
                    {
                    group.SetOrdinalPosition(0);
                    window.SetExtent(TPoint(0, 0), size);
                    window.SetBackgroundColor(TRgb(5, 9, 17));
                    window.SetVisible(ETrue);
                    window.Activate();

                    TReal centerX = 0.0, centerY = 0.0, centerZ = 0.0, modelScale = 1.0;
                    CalculateModelBounds(centerX, centerY, centerZ, modelScale);
                    TProjectedPoint projected[KModelVertexCount];
                    const TRect full(0, 0, size.iWidth, size.iHeight);
                    TReal angle = 0.0;
                    TReal tilt = 0.38;

                    // Automatic rotation for 72 seconds, then clean exit.
                    for (TInt frame = 0; frame < 1800; ++frame)
                        {
                        ProjectModel(projected, angle, tilt, centerX, centerY,
                                     centerZ, modelScale, size.iWidth, size.iHeight);
                        window.BeginRedraw(full);
                        gc.Activate(window);
                        gc.SetBrushStyle(CGraphicsContext::ESolidBrush);
                        gc.SetBrushColor(TRgb(5, 9, 17));
                        gc.SetPenStyle(CGraphicsContext::ESolidPen);
                        gc.SetPenSize(TSize(1, 1));
                        gc.DrawRect(full);
                        DrawModel(gc, projected);
                        gc.Deactivate();
                        window.EndRedraw();
                        session.Flush();
                        angle += 0.035;
                        if (angle > 6.2831853) angle -= 6.2831853;
                        User::After(40000);
                        }

                    window.Close();
                    }
                group.Close();
                }
            }
        }
    }
    session.Close();
    delete cleanup;
    return error;
    }

GLDEF_C TInt E32Main()
    {
    return RunViewer();
    }
