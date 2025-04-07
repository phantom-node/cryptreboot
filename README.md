# Cryptreboot

[![Gem Version](https://badge.fury.io/rb/crypt_reboot.svg)](https://badge.fury.io/rb/crypt_reboot)

Convenient reboot for Linux systems with encrypted root partition.

> Just type `cryptreboot` instead of `reboot`.

It asks for a passphrase and reboots the system afterward, automatically
unlocking the drive on startup using
[in-memory initramfs patching and kexec](https://www.pawelpokrywka.com/p/rebooting-linux-with-encrypted-disk).
Without explicit consent, no secrets are stored on disk, even temporarily.

Useful when unlocking the drive at startup is difficult, such as on headless
and remote systems.

By default, it uses the current kernel command line, `/boot/vmlinuz` as kernel
and `/boot/initrd.img` as initramfs.

Will work properly when using standard passphrase-based disk unlocking.
Fancy methods such as using an external USB with a passphrase file will fail.

## Supported disk encryption methods

### LUKS crypttab
LUKS-based disk-encryption configured with `/etc/crypttab` file.

### ZFS keystore
Native ZFS encryption with LUKS-encrypted keystore volume.

## Compatible Linux distributions

Currently, cryptreboot depends on `initramfs-tools` package which is available in
Debian-based distributions. Therefore one should expect, this tool to work on
Debian, Ubuntu, Linux Mint, Pop!_OS, etc.

On the other hand, do not expect it to work on other distributions now.
But support for them may come in upcoming versions.

Following distributions were tested by the author on the AMD64 machine:

- LUKS crypttab disk encryption method
  - DappNode 0.2.75 is based on Debian 12, see below
  - Debian 12 needs [symlinks for kernel and initramfs](#no-symlinks-to-most-recent-kernel-and-initramfs)
  - Pop!_OS 22.04 LTS
  - Ubuntu 24.04 LTS
  - Ubuntu 23.04
  - Ubuntu 22.04 LTS
  - Ubuntu 20.04 LTS needs tiny adjustments to system settings,
    specifically [changing compression](#lz4-initramfs-compression) and
    [fixing systemd kexec support](#staged-kernel-not-being-executed-by-systemd), but still
    [sometimes](#unable-to-kexec-on-reboot-using-old-systemd) reboot experience may be suboptimal
  - ~~Ubuntu 18.04 LTS~~ is not supported (initramfs uses *pre-crypttab* format)

- ZFS keystore disk encryption method
  - Ubuntu 24.04 LTS
  - Ubuntu 22.04 LTS

If you have successfully run cryptreboot on another distribution,
please contact me and I will update the list.

## Requirements

You need to ensure those are installed:
- `ruby` >= 2.7
- `kexec-tools`
- `initramfs-tools` (other initramfs generators, such as `dracut` are
  not supported yet)

If you use recent, mainstream Linux distribution, other requirements are
probably already met:
- `kexec` support in the kernel
- `ramfs` filesystem support in kernel
- `cryptsetup` (if you use disk encryption, it should be installed)
- `systemd` or another way to guarantee staged kernel is executed on reboot
- `strace` (not required if `--skip-lz4-check` flag is specified)

If you use Debian-based distribution, use this command to install required packages:

    $ sudo apt install --no-install-recommends cryptsetup-initramfs kexec-tools ruby strace systemd

When asked if kexec should handle reboots, answer `yes` (however the answer probably
doesn't matter for cryptreboot to work).

## Installation

Make sure the required software is installed, then install the gem system-wide by executing:

    $ sudo gem install crypt_reboot

To upgrade run:

    $ sudo gem update crypt_reboot

## Usage

Cryptreboot performs operations normally only available to the root user,
so it is suggested to use sudo or a similar utility.

To perform a reboot type:

    $ sudo cryptreboot

To see the usage, run:

    $ cryptreboot --help

## Troubleshooting

### LZ4 initramfs compression

If you get:

> LZ4 compression is not allowed, change the compression algorithm in
initramfs.conf and regenerate the initramfs image

it means initramfs was compressed using the LZ4 algorithm, which seems to
have issues with concatenating initramfs images.

In case you are 100% sure LZ4 won't cause problems, you can use
`--skip-lz4-check` command line flag. This will make the error message
go away, but you risk automatic disk unlocking at startup to fail randomly.

Instead, the recommended approach is to change the compression algorithm
in `/etc/initramfs-tools/initramfs.conf` file. Look for `COMPRESS` and
set it to some other value such as `gzip` (the safe choice), or `zstd`
(the best compression, but your kernel and `initramfs-tools` need to support it).

Here is a one-liner to change compression to `gzip`:

    $ sudo sed -iE 's/^\s*COMPRESS=.*$/COMPRESS=gzip/' /etc/initramfs-tools/initramfs.conf

Then you need to regenerate all of your initramfs images:

    $ sudo update-initramfs -k all -u

That's it.

Resources related to the issue:
- [Appending files to initramfs image - reliable? (StackExchange)](https://unix.stackexchange.com/a/737219)
- [What is the correct frame format for Linux (Lz4 issue)](https://github.com/lz4/lz4/issues/956)
- [Initramfs unpacking failed (Ubuntu bug report)](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1835660)

### Staged kernel not being executed by systemd

If rebooting with cryptreboot doesn't seem to differ from a standard
reboot, it may suggest staged kernel is not being executed by the
`systemd` at the end of the shutdown procedure.

The solution I found is to execute `kexec -e` instead of
`systemctl --force kexec` when the system is ready for a reboot.
To do that `systemd-kexec.service` has to be modified.
To make the change minimal, let's use `systemd drop-in` for that:

    $ sudo mkdir -p /etc/systemd/system/systemd-kexec.service.d/
    $ echo -e "[Service]\nExecStart=\nExecStart=kexec -e" | sudo tee /etc/systemd/system/systemd-kexec.service.d/override.conf

That should work.

To cancel the change, remove the file:

    $ sudo rm /etc/systemd/system/systemd-kexec.service.d/override.conf

### No symlinks to the most recent kernel and initramfs

By default, cryptreboot looks for kernel in `/boot/vmlinuz` and for initramfs
in `/boot/initrd.img`. If those files are missing in your Linux distribution,
cryptreboot will fail, unless you use `--kernel` and `--initramfs` command line
options.

    $ sudo cryptreboot --kernel /boot/vmlinuz-`uname -r` --initramfs /boot/initrd.img-`uname -r`

If you don't want to specify options every time you reboot, add symlinks to
the currently running kernel and initramfs:

    $ cd /boot
    $ sudo ln -sf vmlinuz-`uname -r` vmlinuz
    $ sudo ln -sf initrd.img-`uname -r` initrd.img

Unfortunately, you need to rerun it after each kernel upgrade, otherwise,
cryptreboot is going to boot the old kernel.
Upcoming versions of cryptreboot will offer better solutions.

### Problems with memory locking

If you get:

> Locking error: Failed to lock memory

it means there was an error while locking memory to prevent a risk of sensitive data ending in a swap space.

Make sure you have permission to lock memory. Root users have.
If permissions are ok, then please report a bug describing your setup.

The solution of last resort is to use `--insecure-memory` flag, which disables memory locking completely.

### Unable to kexec on reboot using old systemd

Ubuntu 20.04 ships with `systemd` which may fall back to standard reboot instead of using `kexec`, because this utility
is located on a filesystem being unmounted during the shutdown sequence.

As a result, using cryptreboot would feel like using normal reboot.

To tell if your system is affected, you have to check messages printed to the console after you run cryptreboot.
This message happens just before reboot, so you will have just a few milliseconds to notice it on screen:

> shutdown[1]: (sd-kexec) failed with exit status 1

[There is a fix](https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1969365) waiting to be included in
a stable release update to `systemd` since 2023-07-21.

In the meantime, as a workaround, you can use `kexec` directly. **Warning: it will skip the standard shutdown procedure. Filesystems won't be unmounted, services won't be stopped, etc. It is like hitting `reset` button**.
However, when you use a decent filesystem with journalling the risk of things going bad should not be high.

Given the above warning, to reboot skipping the shutdown procedure, run:

    $ sudo cryptreboot -p
    $ sudo kexec -e # will skip proper shutdown sequence

## Development

After checking out the repo, run `bundle install` to install
dependencies. Then, run `rake spec` to run the tests. You can also
run `bin/console` for an interactive prompt that will allow you
to experiment.

To build the gem, run `rake build`. To release a new version, update
the version number in `version.rb`, and then run `rake release`, which
will create a git tag for the version, push git commits and the created
tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/phantom-node/cryptreboot.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the
[code of conduct](https://github.com/phantom-node/cryptreboot/blob/master/CODE_OF_CONDUCT.md).

## Author

My name is Paweł Pokrywka and I'm the author of cryptreboot.

If you want to contact me or get to know me better, check out
[my blog](https://www.pawelpokrywka.com).

Thank you for your interest in this project :)

## License

The software is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cryptreboot project's codebases, issue
trackers, chat rooms, and mailing lists is expected to follow the
[code of conduct](https://github.com/phantom-node/cryptreboot/blob/master/CODE_OF_CONDUCT.md).
