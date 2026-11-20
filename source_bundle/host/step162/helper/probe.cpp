#include <e32base.h>
#include <f32file.h>

static TInt TryConnect(TInt slots)
    {
    RFs fs;
    const TInt result=fs.Connect(slots);
    if(result==KErrNone) fs.Close();
    return result;
    }

extern "C" TInt ShadowkeyConnectDefault162()
    {
    return TryConnect(KFileServerDefaultMessageSlots);
    }

extern "C" TInt ShadowkeyConnectOneSlot162()
    {
    return TryConnect(1);
    }

extern "C" TInt ShadowkeyConnectTwoSlots162()
    {
    return TryConnect(2);
    }
