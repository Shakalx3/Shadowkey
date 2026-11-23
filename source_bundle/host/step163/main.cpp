#include <e32base.h>
#include <gdi.h>
#include <w32std.h>

static void DrawBits(CWindowGc& gc,TInt value,TInt top,TInt left)
    {
    const TUint32 bits=static_cast<TUint32>(value);
    for(TInt row=0;row<4;++row)
        for(TInt col=0;col<8;++col)
            {
            const TInt bit=31-(row*8+col);
            gc.SetBrushColor((bits&(1u<<bit))?TRgb(255,255,255):TRgb(0,0,0));
            const TInt x=left+col*10,y=top+row*10;
            gc.DrawRect(TRect(x,y,x+7,y+7));
            }
    }

static void DrawPanel(CWindowGc& gc,TInt value,TInt top,TInt left,
                      TRgb identityColor)
    {
    gc.SetPenStyle(CGraphicsContext::ENullPen);
    gc.SetBrushStyle(CGraphicsContext::ESolidBrush);
    gc.SetBrushColor(TRgb(22,22,22));
    gc.DrawRect(TRect(5,top-2,235,top+43));
    gc.SetBrushColor(identityColor);
    gc.DrawRect(TRect(9,top,15,top+40));
    gc.SetBrushColor(value==KErrNone?TRgb(0,230,70):TRgb(255,35,35));
    gc.DrawRect(TRect(220,top+12,232,top+24));
    DrawBits(gc,value,top,left);
    }

int main()
    {
    CTrapCleanup* cleanup=CTrapCleanup::New();
    if(!cleanup) return KErrNoMemory;

    TInt results[3]={KErrGeneral,KErrGeneral,KErrGeneral};
    RLibrary library;
    const TInt loadError=library.Load(_L("ShadowkeyFileServerHelper163.dll"));
    if(loadError==KErrNone)
        {
        typedef TInt (*TProbe)();
        TProbe probes[3]={
            reinterpret_cast<TProbe>(library.Lookup(1)),
            reinterpret_cast<TProbe>(library.Lookup(2)),
            reinterpret_cast<TProbe>(library.Lookup(3))
            };
        for(TInt i=0;i<3;++i)
            results[i]=probes[i]?probes[i]():KErrNotFound;
        library.Close();
        }
    else
        for(TInt i=0;i<3;++i) results[i]=loadError;

    RWsSession session;
    TInt error=session.Connect();
    if(error==KErrNone)
        {
        CWsScreenDevice screen(session);
        error=screen.Construct();
        if(error==KErrNone)
            {
            CWindowGc gc(&screen);
            error=gc.Construct();
            if(error==KErrNone)
                {
                const TSize size=screen.SizeInPixels();
                RWindowGroup group(session);
                error=group.Construct(1,ETrue);
                if(error==KErrNone)
                    {
                    RWindow window(session);
                    error=window.Construct(group,2);
                    if(error==KErrNone)
                        {
                        group.SetOrdinalPosition(0);
                        window.SetExtent(TPoint(0,0),size);
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
                        gc.DrawRect(TRect(size.iWidth/8,size.iHeight/8,size.iWidth*7/8,size.iHeight/8+8));
                        const TInt left=(size.iWidth-80)/2;
                        // Blue: ordinary RFs::Connect; yellow: direct EUSER CreateSession(-1);
                        // purple: direct EUSER CreateSession(0), all with !FileServer and version 0.0.0.
                        DrawPanel(gc,results[0],35,left,TRgb(0,190,255));
                        DrawPanel(gc,results[1],85,left,TRgb(255,180,0));
                        DrawPanel(gc,results[2],135,left,TRgb(220,0,220));
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
