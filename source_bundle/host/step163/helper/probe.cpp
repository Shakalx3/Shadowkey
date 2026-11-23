#include <e32base.h>
#include <f32file.h>

class RDirectFileServerSession : public RFs
    {
public:
    TInt ConnectDirectWithSlots(TInt slots)
        {
        return CreateSession(_L("!FileServer"),TVersion(0,0,0),slots);
        }
    TInt ConnectDirectDefault()
        {
        return CreateSession(_L("!FileServer"),TVersion(0,0,0));
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
    RDirectFileServerSession fs;
    const TInt result=fs.ConnectDirectWithSlots(slots);
    if(result==KErrNone) fs.Close();
    return result;
    }

static TInt TryDirectDefault()
    {
    RDirectFileServerSession fs;
    const TInt result=fs.ConnectDirectDefault();
    if(result==KErrNone) fs.Close();
    return result;
    }

extern "C" TInt ShadowkeyConnectViaRfs163() { return TryConnect(); }
extern "C" TInt ShadowkeyCreateSessionMinusOne163() { return TryDirect(-1); }
extern "C" TInt ShadowkeyCreateSessionZeroSlots163() { return TryDirect(0); }
