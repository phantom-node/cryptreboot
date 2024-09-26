## [0.3.0.beta.1] - 2024-09-26

- Add preliminary support for LUKS-keystore-based ZFS encryption implemented by Ubuntu

## [0.2.1] - 2023-11-12

- Use new MemoryLocker without a need for FFI compilation step

## [0.2.0] - 2023-07-29

- Make memory locking optional with `--insecure-memory` command line option
- Remove FFI gem dependency

## [0.1.2] - 2023-07-22

- Lock memory to prevent secrets leaking to swap
- Use `ramfs` instead of `tmpfs` for the same reason

## [0.1.1] - 2023-07-13

- Standardize passphrase prompt

## [0.1.0] - 2023-07-09

- Initial release
