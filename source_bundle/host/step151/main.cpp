#include <e32base.h>
#include <gdi.h>
#include <w32std.h>

// Step151 loads a genuine EKA2 DLL produced by symbian_add_dynamic_library.
// Green bar means the preceding C-runtime fopen succeeded.
// Matrix displays the exact RLibrary::Load result.
static TInt RunLoaderProbe()
    {
    FILE* file = fopen("C:\\data\\ShadowkeyValidProbe151.dll", "rb");
    if (!file) return KErrNotFound;
    fclose(file);
    RLibrary library;
    const TInt result = library.Load(_L("C:\\data\\ShadowkeyValidProbe151.dll"));
    if (result == KErrNone)
        {
        typedef TInt (*TProbeFunction)();
        TProbeFunction function = reinterpret_cast<TProbeFunction>(library.Lookup(1));
        if (function)
            {
            volatile TInt value = function();
            (void)value;
            }
        library.Close();
        }
    return result;
    }

int main()
    {
    CTrapCleanup* cleanup = CTrapCleanup::New();
    if (!cleanup) return KErrNoMemory;
    const TInt loadError = RunLoaderProbe();
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
                        gc.DrawRect(TRect(size.iWidth/8,size.iHeight/8,size.iWidth*7/8,size.iHeight/8+18));
                        const TUint32 bits = static_cast<TUint32>(loadError);
                        const TInt cell=10,pitch=14,left=(size.iWidth-8*pitch)/2,top=size.iHeight/2-2*pitch;
                        for(TInt row=0;row<4;++row) for(TInt col=0;col<8;++col)
                            {
                            const TInt bit=31-(row*8+col);
                            gc.SetBrushColor((bits&(1u<<bit))?TRgb(255,255,255):TRgb(0,0,0));
                            const TInt x=left+col*pitch,y=top+row*pitch;
                            gc.DrawRect(TRect(x,y,x+cell,y+cell));
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
    session.Close();
    delete cleanup;
    return error;
    }
