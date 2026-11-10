#include <e32cmn.h>
#include <stddef.h>

// Step96: compile-time ABI assertions against the pinned S60 3.1 FP1 ARM SDK.
// These checks deliberately do not provide a replacement implementation.
typedef char step96_tint64_is_8_bytes[(sizeof(TInt64) == 8) ? 1 : -1];
typedef char step96_ttrap_is_76_bytes[(sizeof(TTrap) == 76) ? 1 : -1];
typedef char step96_ttrap_state_offset[(offsetof(TTrap, iState) == 0) ? 1 : -1];
typedef char step96_ttrap_next_offset[(offsetof(TTrap, iNext) == 64) ? 1 : -1];
typedef char step96_ttrap_result_offset[(offsetof(TTrap, iResult) == 68) ? 1 : -1];
typedef char step96_ttrap_handler_offset[(offsetof(TTrap, iHandler) == 72) ? 1 : -1];

typedef TInt (TTrap::*TTrapMemberTrapSignature)(TInt&);
typedef void (*TTrapStaticUnTrapSignature)();

static TTrapMemberTrapSignature const KStep96TrapSignature = &TTrap::Trap;
static TTrapStaticUnTrapSignature const KStep96UnTrapSignature = &TTrap::UnTrap;

extern "C" TInt Step96CallTrap(TTrap* aTrap, TInt& aResult)
    {
    return aTrap->Trap(aResult);
    }

extern "C" void Step96CallUnTrap()
    {
    TTrap::UnTrap();
    }
