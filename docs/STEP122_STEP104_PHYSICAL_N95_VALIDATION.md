# Step122 — physical N95 validation of the Step104 Window Server probe

Date: 2026-11-16

## Device observation

The user supplied a photograph of the Nokia N95 8GB RM-320 displaying the Step104 probe output: a green rectangular field with a white vertical and horizontal cross on the handset display.

This matches the visual output deliberately drawn by `source_bundle/host/step103/main.cpp`. The user-visible result is therefore a successful launch of the Step104 EKA2 probe on the physical target handset and a successful visible draw through the Window Server/GDI path.

## What this validates

- The packaged Step104 application is accepted sufficiently by the handset to start.
- `RWsSession::Connect()` succeeds.
- `CWsScreenDevice::Construct()` and `CWindowGc::Construct()` succeed.
- The probe creates and foregrounds an `RWindowGroup` and `RWindow`.
- The target device displays the expected GDI-drawn green field and white cross.

## What this does not validate

- It is not a launch of the original `6R51.APP` or Shadowkey game code.
- It does not validate the original N-Gage import table, old EKA1 object layouts, AVKON/EIKCORE construction, FBS bitmap memory, the game's resource paths, or the legacy graphics-context vtable adapter.
- It does not establish game input, audio, 3D rendering, save data, or sustained runtime stability.

## Next engineering gate

Keep the visible Step104 probe as the known-good target-side startup/GDI reference. Continue with the original game's executable/import compatibility path, using the reconstructed RM-320 ROM export inventory and the old game's ARM UREL import identities. Do not treat the probe as a compatibility shim for the game, and do not modify ROM files.

The old `6R51.APP` remains a legacy E32 image. The Step35 structural patch test proves only that a narrow rewrite of that legacy image is internally consistent; it is not evidence that the resulting image is accepted by the EKA2 loader. Any next binary patch must be based on a fresh original image and must preserve a reversible, separately testable output.
