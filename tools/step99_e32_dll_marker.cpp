// Minimal EKA2 DLL marker and entry point for the Step99 conversion probe.
// elf2e32 detects a DLL by the presence of the static symbol named _E32Dll.
extern "C" {
__attribute__((used, visibility("hidden"))) int _E32Dll = 0;

// This isolated probe has no static constructors or per-process state.
__attribute__((used, visibility("hidden"))) int E32Dll(int aReason)
    {
    (void)aReason;
    return 0;
    }
}
