#include <e32base.h>
#include <e32std.h>
#include <apparc.h>
#include <eikapp.h>
#include <eikdoc.h>
#include <eikappui.h>
#include <eikstart.h>

static const TUint32 KStep102SameA[2] = {0x11223344u, 0x55667788u};
static const TUint32 KStep102SameB[2] = {0x11223344u, 0x55667788u};
static const TUint32 KStep102LowDiff[2] = {0x11223345u, 0x55667788u};
static const TUint32 KStep102HighDiff[2] = {0x11223344u, 0x55667789u};

_LIT(KStep102DllName, "ShadowkeyCompat.dll");
_LIT(KStep102LoadFail, "SK DLL LOAD FAIL");
_LIT(KStep102LookupFail, "SK DLL LOOKUP FAIL");
_LIT(KStep102CallFail, "SK DLL CALL FAIL");
_LIT(KStep102Pass, "SK DLL PASS");

typedef TInt (*TStep102CompareFn)(const TUint32*, const TUint32*);

static void Step102RunLoaderProbe(TDes& aMessage)
    {
    RLibrary library;
    const TInt loadError = library.Load(KStep102DllName);
    if (loadError != KErrNone)
        {
        aMessage.Copy(KStep102LoadFail);
        return;
        }

    TLibraryFunction raw = library.Lookup(1);
    if (!raw)
        {
        library.Close();
        aMessage.Copy(KStep102LookupFail);
        return;
        }

    TStep102CompareFn compare = reinterpret_cast<TStep102CompareFn>(raw);
    const TBool pass =
        compare(KStep102SameA, KStep102SameB) == 0 &&
        compare(KStep102SameA, KStep102LowDiff) != 0 &&
        compare(KStep102SameA, KStep102HighDiff) != 0;
    library.Close();

    aMessage.Copy(pass ? KStep102Pass : KStep102CallFail);
    }

class CStep102AppUi : public CEikAppUi
    {
public:
    void ConstructL()
        {
        BaseConstructL();
        TBuf<32> result;
        Step102RunLoaderProbe(result);
        User::InfoPrint(result);
        }
    };

class CStep102Document : public CEikDocument
    {
public:
    static CStep102Document* NewL(CEikApplication& aApplication)
        {
        return new (ELeave) CStep102Document(aApplication);
        }

private:
    explicit CStep102Document(CEikApplication& aApplication)
        : CEikDocument(aApplication)
        {
        }

    CEikAppUi* CreateAppUiL()
        {
        return new (ELeave) CStep102AppUi;
        }
    };

class CStep102Application : public CEikApplication
    {
private:
    TUid AppDllUid() const
        {
        return TUid::Uid(0xE000BEF0);
        }

    CApaDocument* CreateDocumentL()
        {
        return CStep102Document::NewL(*this);
        }
    };

LOCAL_C CApaApplication* NewApplication()
    {
    return new CStep102Application;
    }

GLDEF_C TInt E32Main()
    {
    TApaApplicationFactory factory(&NewApplication);
    return EikStart::RunApplication(factory);
    }
