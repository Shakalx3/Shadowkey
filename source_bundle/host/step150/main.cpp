#include <e32base.h>
#include <stdio.h>
#include <gdi.h>
#include <w32std.h>

// Step150 separates C-runtime file visibility from the EKA2 loader result.
// The upper status bar is green only when fopen() opened the test file.
// The lower 32-cell matrix displays the exact RLibrary::Load() result.
// If fopen fails, the loader is not called and the matrix is omitted.
struct TProbeResult
    {
    TInt iFopenError;
    TInt iLoadError;
    TBool iFopenSucceeded;
    };

static TProbeResult RunProbe()
    {
    TProbeResult result;
    result.iFopenError = KErrNotFound;
    result.iLoadError = KErrNotReady; // sentinel: loader was not called
    result.iFopenSucceeded = EFalse;

    FILE* file = fopen("C:\\data\\ShadowkeyLegacyProbe.dll", "rb");
    if (!file)
        return result;

    result.iFopenSucceeded = ETrue;
    result.iFopenError = KErrNone;
    fclose(file);

    RLibrary library;
    result.iLoadError = library.Load(_L("C:\\data\\ShadowkeyLegacyProbe.dll"));
    if (result.iLoadError == KErrNone)
        library.Close();
    return result;
    }

int main()
    {
    CTrapCleanup* cleanup = CTrapCleanup::New();
    if (!cleanup)
        return KErrNoMemory;

    const TProbeResult result = RunProbe();
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
    window.BeginRedraw(full);
    gc.Activate(window);
    gc.SetPenStyle(CGraphicsContext::ENullPen);
    gc.SetBrushStyle(CGraphicsContext::ESolidBrush);
    gc.SetBrushColor(TRgb(0,0,0)); gc.DrawRect(full);

    // Dedicated fopen status indicator: unmistakably green on success.
    gc.SetBrushColor(result.iFopenSucceeded ? TRgb(0,220,80) : TRgb(240,32,32));
    gc.DrawRect(TRect(size.iWidth/8,size.iHeight/8,size.iWidth*7/8,size.iHeight/8+18));

    // Loader result occupies a separate matrix below the status bar.
    if (result.iFopenSucceeded)
        {
        const TUint32 bits = static_cast<TUint32>(result.iLoadError);
        const TInt cell=10,pitch=14,gridLeft=(size.iWidth-8*pitch)/2;
        const TInt gridTop=size.iHeight/2-2*pitch;
        for(TInt row=0;row<4;++row) for(TInt col=0;col<8;++col)
            {
            const TInt bit=31-(row*8+col);
            gc.SetBrushColor((bits&(1u<<bit))?TRgb(255,255,255):TRgb(0,0,0));
            const TInt x=gridLeft+col*pitch,y=gridTop+row*pitch;
            gc.DrawRect(TRect(x,y,x+cell,y+cell));
            }
        }
    gc.Deactivate(); window.EndRedraw(); session.Flush(); User::After(8000000);
    window.Close();
    }
    group.Close();
    }
    }
    }
    }
    session.Close(); delete cleanup; return error;
    }
