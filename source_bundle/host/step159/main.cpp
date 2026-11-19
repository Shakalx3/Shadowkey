#include <e32base.h>
#include <stdio.h>
#include <gdi.h>
#include <w32std.h>

static TInt RunFileServerHelper()
    {
    RLibrary library;
    const TInt loadError=library.Load(_L("ShadowkeyFileServerHelper159.dll"));
    if(loadError!=KErrNone) return loadError;
    typedef TInt (*THelperFunction)();
    THelperFunction function=reinterpret_cast<THelperFunction>(library.Lookup(1));
    const TInt result=function ? function() : KErrNotFound;
    library.Close();
    return result;
    }

static TInt LoadFileServerDll()
    {
    RLibrary library;
    const TInt result=library.Load(_L("efsrv.dll"));
    if(result!=KErrNone) return result;
    library.Close();
    return KErrNone;
    }

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
                      TRgb identityColor,TBool passed)
    {
    gc.SetPenStyle(CGraphicsContext::ENullPen);
    gc.SetBrushStyle(CGraphicsContext::ESolidBrush);
    gc.SetBrushColor(TRgb(22,22,22));
    gc.DrawRect(TRect(5,top-2,235,top+43));
    gc.SetBrushColor(identityColor);
    gc.DrawRect(TRect(9,top,15,top+40));
    gc.SetBrushColor(passed?TRgb(0,230,70):TRgb(255,35,35));
    gc.DrawRect(TRect(220,top+12,232,top+24));
    DrawBits(gc,value,top,left);
    }

int main()
    {
    CTrapCleanup* cleanup=CTrapCleanup::New();
    if(!cleanup) return KErrNoMemory;

    FILE* file=fopen("C:\\sys\\bin\\ShadowkeyFileServerHelper159.dll","rb");
    const TInt cFileResult=file?1:0;
    if(file) fclose(file);

    const TInt helperResult=RunFileServerHelper();
    const TInt efsrvResult=LoadFileServerDll();

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
                        DrawPanel(gc,cFileResult,35,left,TRgb(0,190,255),cFileResult==1);
                        const TInt helperValue=helperResult>=0?helperResult:0;
                        DrawPanel(gc,helperValue,85,left,TRgb(255,180,0),helperResult>=0 && (helperResult&1));
                        DrawPanel(gc,efsrvResult,135,left,TRgb(220,0,220),efsrvResult==KErrNone);
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
