#include <e32base.h>
#include <e32std.h>
#include <apparc.h>
#include <aknapp.h>
#include <akndoc.h>
#include <aknappui.h>
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
_LIT(KStep102PanicCategory, "SKProbe");

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

    if (pass)
        aMessage.Copy(KStep102Pass);
    else
        aMessage.Copy(KStep102CallFail);
    }

class CStep102AppUi : public CAknAppUi
    {
public:
    void ConstructL()
        {
        BaseConstructL();
        TBuf<32> result;
        Step102RunLoaderProbe(result);
        User::InfoPrint(result);
        }

    // Symbian interface reserve slots: preserve the S60 vtable shape.
    void MCoeMessageObserver_Reserved_2() {}
    void MObjectProvider_Reserved1() {}
    void MObjectProvider_Reserved2() {}
    void MCoeViewDeactivationObserver_Reserved_1() {}
    void MCoeViewDeactivationObserver_Reserved_2() {}
    };

class CStep102Document : public CAknDocument
    {
public:
    static CStep102Document* NewL(CEikApplication& aApplication)
        {
        return new (ELeave) CStep102Document(aApplication);
        }

private:
    explicit CStep102Document(CEikApplication& aApplication)
        : CAknDocument(aApplication)
        {
        }

    CEikAppUi* CreateAppUiL()
        {
        return new (ELeave) CStep102AppUi;
        }
    };

class CStep102Application : public CAknApplication
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


// EKA2/GCCE uses the Symbian heap for C++ object deletion.
void operator delete(void* aPtr)
    {
    User::Free(aPtr);
    }

void operator delete[](void* aPtr)
    {
    User::Free(aPtr);
    }

// A pure virtual call is a programming error; keep a deterministic panic
// target for the interface reserve slots in the target SDK vtables.
extern "C" void __cxa_pure_virtual()
    {
    User::Panic(KStep102PanicCategory, KErrNotSupported);
    }
