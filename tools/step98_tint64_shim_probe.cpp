#include <stdint.h>
#include <stddef.h>

// Isolated ABI candidate for the legacy N-Gage TInt64::operator!= call.
// The object representation is supported by the N-Gage 6.1 SDK header:
// protected TUint iLow; TUint iHigh;. This is not yet wired into 6R51.APP.
extern "C" int Step98TInt64NotEqual(const uint32_t* aThis, const uint32_t* aOther)
    {
    return (aThis[0] != aOther[0]) || (aThis[1] != aOther[1]);
    }

#if defined(STEP98_HOST_TEST)
#include <assert.h>
int main()
    {
    const uint32_t a[2] = {0x11223344u, 0x55667788u};
    const uint32_t same[2] = {0x11223344u, 0x55667788u};
    const uint32_t low_diff[2] = {0x11223345u, 0x55667788u};
    const uint32_t high_diff[2] = {0x11223344u, 0x55667789u};
    assert(Step98TInt64NotEqual(a, same) == 0);
    assert(Step98TInt64NotEqual(a, low_diff) == 1);
    assert(Step98TInt64NotEqual(a, high_diff) == 1);
    return 0;
    }
#endif