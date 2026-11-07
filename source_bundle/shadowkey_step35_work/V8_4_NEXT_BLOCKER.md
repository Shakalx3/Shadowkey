# v8.4 next blocker

The SystemGc null-return failure has been crossed with a diagnostic-only synthetic object. The next failure is a null pointer loaded from `0x10111208 + 0x14A3C` inside `sub_1001f9ac`; the following read at `0x80` faults. The 0x10111208 source block is 0x14E14 bytes, so the field is within the allocation but was never populated in this run. Trace the object's constructor and all writers to this field before adding any HLE behavior.
