#include <e32base.h>
#include <f32file.h>

extern "C" TInt ShadowkeyFileServerHelper159()
    {
    RFs fs;
    const TInt connectError=fs.Connect();
    if(connectError!=KErrNone) return 0;

    _LIT(KProbePath,"C:\\sys\\bin\\ShadowkeyFileServerHelper159.dll");
    TEntry entry;
    const TInt entryError=fs.Entry(KProbePath,entry);

    RFile file;
    const TInt openError=file.Open(fs,KProbePath,EFileRead|EFileShareReadersOnly);
    if(openError==KErrNone) file.Close();
    fs.Close();

    TInt result=1;
    if(entryError==KErrNone) result|=2;
    if(openError==KErrNone) result|=4;
    return result;
    }
