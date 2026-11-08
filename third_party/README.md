# Third-party SDK sources

## N-Gage / Symbian 6.1 SDK

The upstream SDK is linked as a Git submodule at `third_party/ngage-sdk`:

- Repository: https://github.com/ngagesdk/sdk
- Pinned upstream commit: `0a94b7655117f325a1729f5600093e4ad12c8d60`
- Snapshot size reported by GitHub: 9,936 files, approximately 458 MB unpacked.

This repository contains Nokia and third-party SDK components. The upstream N-Gage toolchain project explicitly notes that the SDK components are not covered by its MIT license. To avoid creating an unauthorized second copy, this project pins the public upstream repository instead of duplicating all SDK binaries and proprietary material into this repository. The submodule records an exact reproducible revision.

Initialize it after cloning with:

```sh
git submodule update --init --recursive
```

The N-Gage SDK is the legacy S60 1st Edition / Symbian 6.1 environment used for the original N-Gage build. It must not be confused with the S60 3.1 FP1 / Symbian OS 9.2 SDK for the Nokia N95.
