#include <e32base.h>
#include <e32std.h>
#include <apparc.h>
#include <eikstart.h>

// The original 6R51.APP is an application DLL whose ordinal 1 is its
// NewApplication-style factory. Keep the library loaded for the entire
// EikStart::RunApplication lifetime.
static RLibrary gLegacyAppLibrary;

static CApaApplication* NewLegacyApplication()
    {
    TLibraryFunction entry = gLegacyAppLibrary.Lookup(1);
    if (!entry)
        User::Leave(KErrNotFound);

    TApaApplicationFactory::TFunction factory =
        reinterpret_cast<TApaApplicationFactory::TFunction>(entry);
    return factory();
    }

GLDEF_C TInt E32Main()
    {
    CTrapCleanup* cleanup = CTrapCleanup::New();
    if (!cleanup)
        return KErrNoMemory;

    TInt result = KErrNone;
    TRAP(result,
        User::LeaveIfError(gLegacyAppLibrary.Load(_L("6R51")));
        TApaApplicationFactory factory(&NewLegacyApplication);
        result = EikStart::RunApplication(factory);
    );

    gLegacyAppLibrary.Close();
    delete cleanup;
    return result;
    }
