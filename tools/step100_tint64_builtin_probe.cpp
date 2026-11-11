#include <e32cmn.h>

// Step100: verify the target SDK's TInt64 category and native 64-bit operator codegen.
template <typename T>
struct Step100IsClass
    {
    template <typename U> static char Test(int U::*);
    template <typename U> static long Test(...);
    enum { Value = sizeof(Test<T>(0)) == sizeof(char) };
    };

typedef char Step100TInt64IsEightBytes[(sizeof(TInt64) == 8) ? 1 : -1];
typedef char Step100TInt64IsSigned[((TInt64)-1 < (TInt64)0) ? 1 : -1];
typedef char Step100TInt64IsPrimitive[(Step100IsClass<TInt64>::Value == 0) ? 1 : -1];

extern "C" TInt Step100TInt64GetTInt(const TInt64* aThis)
    {
    return (TInt)*aThis;
    }

extern "C" TBool Step100TInt64NotEqual(const TInt64* aThis, const TInt64* aOther)
    {
    return *aThis != *aOther;
    }

extern "C" TBool Step100TInt64Equal(const TInt64* aThis, const TInt64* aOther)
    {
    return *aThis == *aOther;
    }

extern "C" TInt64 Step100TInt64Subtract(const TInt64* aThis, const TInt64* aOther)
    {
    return *aThis - *aOther;
    }

extern "C" TInt64 Step100TInt64Divide(const TInt64* aThis, const TInt64* aOther)
    {
    return *aThis / *aOther;
    }

extern "C" void Step100TInt64Construct(TInt64* aThis, TInt aValue)
    {
    *aThis = (TInt64)aValue;
    }
