#include <e32base.h>
#include <gdi.h>
#include <w32std.h>

// Step142: the compatibility routine is linked into this EXE.
// No RLibrary, no separate DLL, no sys\\bin payload.
static TInt Step142TInt64NotEqual(const TUint32* aThis,
                                  const TUint32* aOther)
    {
    return (aThis[0] != aOther[0]) || (aThis[1] != aOther[1]);
    }

static TRgb ProbeColor()
    {
    const TUint32 left[2] = { 0x89ABCDEFu, 0x01234567u };
    const TUint32 same[2] = { 0x89ABCDEFu, 0x01234567u };
    const TUint32 lowDiff[2] = { 0x89ABCDEEu, 0x01234567u };
    const TUint32 highDiff[2] = { 0x89ABCDEFu, 0x01234566u };

    const TBool equalPass = Step142TInt64NotEqual(left, same) == 0;
    const TBool lowPass = Step142TInt64NotEqual(left, lowDiff) != 0;
    const TBool highPass = Step142TInt64NotEqual(left, highDiff) != 0;

    return (equalPass && lowPass && highPass)
        ? TRgb(0, 160, 72)
        : TRgb(200, 24, 24);
    }

int main()
    {
    CTrapCleanup* cleanup = CTrapCleanup::New();
    if (!cleanup) return KErrNoMemory;

    const TRgb resultColor = ProbeColor();
    RWsSession session;
    TInt error = session.Connect();
    if (error != KErrNone) { delete cleanup; return error; }

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
                    const TRect full(0,0,size.iWidth,size.iHeight);
                    const TInt left=size.iWidth/8, top=size.iHeight/8;
                    const TInt right=size.iWidth*7/8, bottom=size.iHeight*7/8;
                    window.BeginRedraw(full);
                    gc.Activate(window);
                    gc.SetPenStyle(CGraphicsContext::ENullPen);
                    gc.SetBrushStyle(CGraphicsContext::ESolidBrush);
                    gc.SetBrushColor(TRgb(0,0,0)); gc.DrawRect(full);
                    gc.SetBrushColor(resultColor);
                    gc.DrawRect(TRect(left,top,right,bottom));
                    gc.SetBrushColor(TRgb(255,255,255));
                    gc.DrawRect(TRect(size.iWidth/2-5,top+12,size.iWidth/2+5,bottom-12));
                    gc.DrawRect(TRect(left+12,size.iHeight/2-5,right-12,size.iHeight/2+5));
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
