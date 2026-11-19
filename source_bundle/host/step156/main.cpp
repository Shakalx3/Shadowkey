#include <e32base.h>
#include <stdio.h>
#include <gdi.h>
#include <w32std.h>

static TInt LoadByName()
    {
    RLibrary library;
    const TInt result = library.Load(_L("ShadowkeyValidProbe156.dll"));
    if (result == KErrNone)
        {
        typedef TInt (*TProbeFunction)();
        TProbeFunction function = reinterpret_cast<TProbeFunction>(library.Lookup(1));
        const TInt value = function ? function() : KErrNotFound;
        library.Close();
        return value;
        }
    return result;
    }

static TInt LoadByFullPath()
    {
    RLibrary library;
    const TInt result = library.Load(_L("C:\\sys\\bin\\ShadowkeyValidProbe156.dll"));
    if (result == KErrNone)
        {
        typedef TInt (*TProbeFunction)();
        TProbeFunction function = reinterpret_cast<TProbeFunction>(library.Lookup(1));
        const TInt value = function ? function() : KErrNotFound;
        library.Close();
        return value;
        }
    return result;
    }

static void DrawBits(CWindowGc& gc, TInt value, TInt top, TInt left)
    {
    const TUint32 bits = static_cast<TUint32>(value);
    const TInt cell = 7;
    const TInt pitch = 10;
    for (TInt row = 0; row < 4; ++row)
        for (TInt col = 0; col < 8; ++col)
            {
            const TInt bit = 31 - (row * 8 + col);
            gc.SetBrushColor((bits & (1u << bit)) ? TRgb(255,255,255) : TRgb(0,0,0));
            const TInt x = left + col * pitch;
            const TInt y = top + row * pitch;
            gc.DrawRect(TRect(x,y,x+cell,y+cell));
            }
    }

static void DrawPanel(CWindowGc& gc, TInt value, TInt top, TInt left,
                      TRgb identityColor, TBool passed)
    {
    const TInt screenWidth = 240;
    gc.SetPenStyle(CGraphicsContext::ENullPen);
    gc.SetBrushStyle(CGraphicsContext::ESolidBrush);

    // Dark panel, separated vertically from the other two diagnostics.
    gc.SetBrushColor(TRgb(22,22,22));
    gc.DrawRect(TRect(8, top-6, screenWidth-8, top+48));

    // Unique identity stripe: cyan=file, amber=short name, magenta=full path.
    gc.SetBrushColor(identityColor);
    gc.DrawRect(TRect(14, top, 20, top+42));

    // Independent outcome marker: green=expected result, red=unexpected result.
    gc.SetBrushColor(passed ? TRgb(0,230,70) : TRgb(255,35,35));
    gc.DrawRect(TRect(screenWidth-28, top+12, screenWidth-14, top+26));

    DrawBits(gc, value, top+3, left);
    }

int main()
    {
    CTrapCleanup* cleanup = CTrapCleanup::New();
    if (!cleanup) return KErrNoMemory;

    FILE* file = fopen("C:\\sys\\bin\\ShadowkeyValidProbe156.dll", "rb");
    const TInt fileFound = file ? 1 : 0;
    if (file) fclose(file);

    const TInt shortResult = LoadByName();
    const TInt fullPathResult = LoadByFullPath();

    RWsSession session;
    TInt error = session.Connect();
    if (error == KErrNone)
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
                        window.SetExtent(TPoint(0,0), size);
                        window.SetBackgroundColor(TRgb(0,0,0));
                        window.SetVisible(ETrue);
                        window.Activate();
                        window.BeginRedraw(TRect(0,0,size.iWidth,size.iHeight));
                        gc.Activate(window);
                        gc.SetPenStyle(CGraphicsContext::ENullPen);
                        gc.SetBrushStyle(CGraphicsContext::ESolidBrush);
                        gc.SetBrushColor(TRgb(0,0,0));
                        gc.DrawRect(TRect(0,0,size.iWidth,size.iHeight));
                        gc.SetBrushColor(TRgb(0,220,80));
                        gc.DrawRect(TRect(size.iWidth/8,size.iHeight/8,size.iWidth*7/8,size.iHeight/8+12));

                        const TInt left = (size.iWidth - 8*10)/2;
                        DrawPanel(gc, fileFound, size.iHeight/4, left,
                                  TRgb(0,190,255), fileFound == 1);
                        DrawPanel(gc, shortResult, size.iHeight/4+70, left,
                                  TRgb(255,180,0), shortResult == 156);
                        DrawPanel(gc, fullPathResult, size.iHeight/4+140, left,
                                  TRgb(220,0,220), fullPathResult == 156);

                        gc.Deactivate();
                        window.EndRedraw();
                        session.Flush();
                        User::After(8000000);
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
