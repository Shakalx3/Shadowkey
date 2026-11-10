// Isolated ABI candidate for the legacy N-Gage TInt64::operator!= call.
// The N-Gage 6.1 SDK declares TUint iLow; TUint iHigh;.
// Keep the primitive type available to the legacy GCCE compiler: its bundled
// headers do not provide the modern C++ <stdint.h> header.
typedef unsigned int TUint32;
typedef char Step98Require32BitUint[(sizeof(TUint32) == 4) ? 1 : -1];

extern "C" int Step98TInt64NotEqual(const TUint32* aThis, const TUint32* aOther)
    {
    return (aThis[0] != aOther[0]) || (aThis[1] != aOther[1]);
    }

#if defined(STEP98_HOST_TEST)
#include <assert.h>
int main()
    {
    const TUint32 a[2] = {0x11223344u, 0x55667788u};
    const TUint32 same[2] = {0x11223344u, 0x55667788u};
    const TUint32 low_diff[2] = {0x11223345u, 0x55667788u};
    const TUint32 high_diff[2] = {0x11223344u, 0x55667789u};
    assert(Step98TInt64NotEqual(a, same) == 0);
    assert(Step98TInt64NotEqual(a, low_diff) == 1);
    assert(Step98TInt64NotEqual(a, high_diff) == 1);
    return 0;
    }
#endif
