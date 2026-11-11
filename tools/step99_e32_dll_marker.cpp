// Minimal EKA2 DLL entry point for the Step99 conversion probe.
// elf2e32 recognizes a DLL by the presence of the static _E32Dll symbol.
extern "C" __attribute__((used, visibility("hidden"))) int _E32Dll(int aReason)
    {
    // The isolated comparison shim has no static constructors or per-process state.
    (void)aReason;
    return 0;
    }
