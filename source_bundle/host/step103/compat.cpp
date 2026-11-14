extern "C" int Step98TInt64NotEqual(const unsigned int* aThis,
                                     const unsigned int* aOther)
    {
    return (aThis[0] != aOther[0]) || (aThis[1] != aOther[1]);
    }
