#include <e32base.h>
#include <f32file.h>

static TInt TryConnect(TInt slots)
    {
    RFs fs;
    const TInt result=fs.Connect(slots);
    if(result==KErrNone) fs.Close();
    return result;
    }

extern "C" TInt ShadowkeyConnectDefault161()
    {
    return TryConnect(KFileServerDefaultMessageSlots);
    }

extern "C" TInt ShadowkeyConnectOneSlot161()
    {
    return TryConnect(1);
    }

extern "C" TInt ShadowkeyConnectTwoSlots161()
    {
    return TryConnect(2);
    }
