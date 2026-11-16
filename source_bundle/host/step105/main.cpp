#include <e32base.h>
#include <gdi.h>
#include <w32std.h>

// Step105 combines the proven Step104 Window Server path with a real
// RLibrary/ordinal-1 call into the local TInt64 inequality shim.
// It deliberately avoids AVKON/EIKCORE and font rendering.
typedef TInt (*TInt64NotEqualFn)(const TUint32*, const TUint32*);

static TRgb ProbeColor()
    {
    RLibrary library;
    TInt error = library.Load(_L("ShadowkeyCompat.dll"));
    if (error != KErrNone)
        return TRgb(220, 160, 0); // amber: DLL load failed

    TLibraryFunction ordinal = library.Lookup(1);
    if (!ordinal)
        {
        library.Close();
        return TRgb(200, 24, 24); // red: ordinal lookup failed
        }

    TInt64NotEqualFn notEqual =
        reinterpret_cast<TInt64NotEqualFn>(ordinal);

    // TInt64 is two 32-bit words: iLow first, then iHigh.
    const TUint32 left[2] = { 0x89ABCDEFu, 0x01234567u };
    const TUint32 same[2] = { 0x89ABCDEFu, 0x01234567u };
    const TUint32 lowDiff[2] = { 0x89ABCDEEu, 0x01234567u };
    const TUint32 highDiff[2] = { 0x89ABCDEFu, 0x01234566u };

    const TBool equalPass = notEqual(left, same) == 0;
    const TBool lowPass = notEqual(left, lowDiff) != 0;
    const TBool highPass = notEqual(left, highDiff) != 0;

    library.Close();
    return (equalPass && lowPass && highPass)
        ? TRgb(0, 160, 72)   // green: load, lookup and ABI checks passed
        : TRgb(200, 24, 24); // red: function returned an unexpected result
    }

int main()
    {
    CTrapCleanup* cleanup = CTrapCleanup::New();
    if (!cleanup)
        return KErrNoMemory;

    // Run the shim call before drawing; the visible color reports its result.
    const TRgb resultColor = ProbeColor();

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
                        gc.SetBrushColor(resultColor);
                        gc.DrawRect(TRect(left, top, right, bottom));
                        gc.SetBrushColor(TRgb(255, 255, 255));
                        gc.DrawRect(TRect(size.iWidth / 2 - 5, top + 12,
                                          size.iWidth / 2 + 5, bottom - 12));
                        gc.DrawRect(TRect(left + 12, size.iHeight / 2 - 5,
                                          right - 12, size.iHeight / 2 + 5));
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
