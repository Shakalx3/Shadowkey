#include <e32base.h>
#include <gdi.h>
#include <w32std.h>

// Step104 is a visible Window Server startup probe. It deliberately avoids
// AVKON/EIKCORE so that a successful launch proves only the EKA2 process,
// Window Server session, GDI drawing and foreground-window path.
int main()
    {
    CTrapCleanup* cleanup = CTrapCleanup::New();
    if (!cleanup)
        return KErrNoMemory;

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
                {
                error = KErrNotSupported;
                }
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
                        window.BeginRedraw(full);
                        gc.Activate(window);
                        gc.SetPenStyle(CGraphicsContext::ENullPen);
                        gc.SetBrushStyle(CGraphicsContext::ESolidBrush);
                        gc.SetBrushColor(TRgb(0, 0, 0));
                        gc.DrawRect(full);

                        // A high-contrast green field with a white cross is
                        // unmistakable on the N95 display and needs no font.
                        const TInt left = size.iWidth / 8;
                        const TInt top = size.iHeight / 8;
                        const TInt right = size.iWidth * 7 / 8;
                        const TInt bottom = size.iHeight * 7 / 8;
                        gc.SetBrushColor(TRgb(0, 160, 72));
                        gc.DrawRect(TRect(left, top, right, bottom));
                        gc.SetBrushColor(TRgb(255, 255, 255));
                        gc.DrawRect(TRect(size.iWidth / 2 - 5, top + 12,
                                          size.iWidth / 2 + 5, bottom - 12));
                        gc.DrawRect(TRect(left + 12, size.iHeight / 2 - 5,
                                          right - 12, size.iHeight / 2 + 5));
                        gc.Deactivate();
                        window.EndRedraw();
                        session.Flush();

                        // Keep the visible proof on screen long enough to
                        // observe, then close cleanly without user input.
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
