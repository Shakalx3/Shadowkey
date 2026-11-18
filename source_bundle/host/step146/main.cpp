#include <e32base.h>
#include <gdi.h>
#include <w32std.h>

// Step144: keep the application executable in sys\bin, but place the
// candidate module in C:\data and ask the EKA2 loader to load it by full path.
// The one-byte module is deliberately invalid: KErrCorrupt would show that
// the loader found the file; KErrNotFound would indicate path/lookup failure.
static TInt ProbeDataPath()
    {
    RLibrary library;
    const TInt loadError = library.Load(_L("C:\\data\\ShadowkeyLegacyProbe.dll"));
    if (loadError != KErrNone)
        return loadError;
    const TLibraryFunction factory = library.Lookup(1);
    library.Close();
    return factory ? KErrNone : KErrNotFound;
    }

int main()
    {
    CTrapCleanup* cleanup = CTrapCleanup::New();
    if (!cleanup)
        return KErrNoMemory;

    const TInt result = ProbeDataPath();
    const TBool loadedAndResolved = (result == KErrNone);

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
            if (size.iWidth < 120 || size.iHeight < 160 ||
                size.iWidth > 8192 || size.iHeight > 8192)
                error = KErrNotSupported;
            else
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
                        window.SetExtent(TPoint(0, 0), size);
                        window.SetBackgroundColor(TRgb(0, 0, 0));
                        window.SetVisible(ETrue);
                        window.Activate();
                        const TRect full(0, 0, size.iWidth, size.iHeight);
                        const TInt left = size.iWidth / 8;
                        const TInt top = size.iHeight / 8;
                        const TInt right = size.iWidth * 7 / 8;
                        const TInt bottom = size.iHeight * 7 / 8;
                        window.BeginRedraw(full);
                        gc.Activate(window);
                        gc.SetPenStyle(CGraphicsContext::ENullPen);
                        gc.SetBrushStyle(CGraphicsContext::ESolidBrush);
                        gc.SetBrushColor(TRgb(0, 0, 0));
                        gc.DrawRect(full);
                        gc.SetBrushColor(loadedAndResolved ? TRgb(0,160,72) : TRgb(190,32,32));
                        gc.DrawRect(TRect(left, top, right, bottom));
                        if (loadedAndResolved)
                            {
                            gc.SetBrushColor(TRgb(255,255,255));
                            gc.DrawRect(TRect(size.iWidth/2-5, top+12, size.iWidth/2+5, bottom-12));
                            gc.DrawRect(TRect(left+12, size.iHeight/2-5, right-12, size.iHeight/2+5));
                            }
                        else
                            {
                            const TUint32 bits = static_cast<TUint32>(result);
                            const TInt cell = 10, pitch = 14;
                            const TInt gridLeft = (size.iWidth - 8*pitch)/2;
                            const TInt gridTop = (size.iHeight - 4*pitch)/2;
                            for (TInt row=0; row<4; ++row)
                                for (TInt col=0; col<8; ++col)
                                    {
                                    const TInt bit = 31-(row*8+col);
                                    gc.SetBrushColor((bits & (1u<<bit)) ? TRgb(255,255,255) : TRgb(0,0,0));
                                    const TInt x=gridLeft+col*pitch, y=gridTop+row*pitch;
                                    gc.DrawRect(TRect(x,y,x+cell,y+cell));
                                    }
                            }
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
    }
    session.Close();
    delete cleanup;
    return error;
    }
