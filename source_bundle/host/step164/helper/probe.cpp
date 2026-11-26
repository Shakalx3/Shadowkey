#include <e32base.h>
#include <f32file.h>

class RDirectFileServerSession : public RFs
    {
public:
    TInt ConnectDirect(const TVersion& version,TInt slots)
        {
        return CreateSession(_L("!FileServer"),version,slots);
        }
    };

static TInt TryConnect()
    {
    RFs fs;
    const TInt result=fs.Connect();
    if(result==KErrNone) fs.Close();
    return result;
    }

static TInt TryDirect(TInt slots)
    {
    RFs versionSource;
    const TVersion clientVersion=versionSource.Version();
    RDirectFileServerSession fs;
    const TInt result=fs.ConnectDirect(clientVersion,slots);
    if(result==KErrNone) fs.Close();
    return result;
    }

extern "C" TInt ShadowkeyConnectViaRfs164() { return TryConnect(); }
extern "C" TInt ShadowkeyCreateSessionVersionMinusOne164() { return TryDirect(-1); }
extern "C" TInt ShadowkeyCreateSessionVersionZero164() { return TryDirect(0); }
