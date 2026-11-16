// Register-level ABI for the legacy EUSER TInt64::operator!= import.
// ARM AAPCS: r0 = this pointer, r1 = other TInt64 pointer, r0 = TInt result.
// TInt64 layout in the N-Gage SDK is iLow at +0 and iHigh at +4.
extern "C" int Step105TInt64NotEqual(const unsigned int* aThis,
                                     const unsigned int* aOther)
    {
    return (aThis[0] != aOther[0]) || (aThis[1] != aOther[1]);
    }
