#include <e32std.h>
#include <e32ldr.h>

typedef TInt (*TStep102CompareFn)(const TUint32*, const TUint32*);

static TInt Step103Report(const TDesC& aMessage, TInt aResult)
    {
    User::InfoPrint(aMessage);
    User::After(3000000);
    return aResult;
    }

int main(int, char**)
    {
    RLibrary library;
    TInt error = library.Load(_L("ShadowkeyCompat.dll"));
    if (error != KErrNone)
        return Step103Report(_L("SK DLL LOAD FAIL"), error);

    TLibraryFunction raw = library.Lookup(1);
    if (!raw)
        {
        library.Close();
        return Step103Report(_L("SK DLL LOOKUP FAIL"), KErrNotFound);
        }

    TStep102CompareFn compare = reinterpret_cast<TStep102CompareFn>(raw);

    const TUint32 sameA[2] = {0x11223344u, 0x55667788u};
    const TUint32 sameB[2] = {0x11223344u, 0x55667788u};
    const TUint32 lowDiff[2] = {0x11223345u, 0x55667788u};
    const TUint32 highDiff[2] = {0x11223344u, 0x55667789u};

    const TBool pass =
        compare(sameA, sameB) == 0 &&
        compare(sameA, lowDiff) != 0 &&
        compare(sameA, highDiff) != 0;

    library.Close();

    if (!pass)
        return Step103Report(_L("SK DLL CALL FAIL"), KErrGeneral);

    return Step103Report(_L("SK DLL PASS"), KErrNone);
    }
