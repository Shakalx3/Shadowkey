# v7 addendum

This bundle adds the full user-supplied game asset tree under `game_assets/`, plus a diagnostic VFS HLE and trace script.

From this directory run:

```sh
./build_and_test.sh
./trace_asset_loader_vfs.sh
```

The VFS trace is diagnostic only. It uses host `FILE*` handles and provisional EFSRV/EUSER ordinal behavior to exercise the lifted game code on the development host. It is not an implementation of Symbian's full file server ABI and does not produce a phone-runnable binary.
