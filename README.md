# Cryptreboot

Convenient reboot for Linux systems with encrypted root partition.
Just type `cryptreboot` instead of `reboot`.

It asks for a passphrase and reboots the system afterward, automatically
unlocking the drive on startup using in-memory initramfs patching and kexec.
Without explicit consent, no secrets are stored on disk, even temporarily.

Useful when unlocking the drive at startup is difficult, such as on headless
and remote systems.

By default, it uses the current kernel command line, `/boot/vmlinuz` as kernel
and `/boot/initrd.img` as initramfs.

Will work properly when using standard passphrase-based disk unlocking.
Fancy methods such as using an external USB with a passphrase file will fail.

## Tested operating systems

- Ubuntu 22.04 LTS works out of the box
- Ubuntu 20.04 LTS needs small adjustments to system settings,
  specifically [changing compression](#lz4-initramfs-compression) and
  [fixing systemd kexec support](#staged-kernel-not-being-executed-by-systemd)
- ~~Ubuntu 18.04 LTS~~ is not supported (initramfs uses pre-crypttab format)

## Requirements

You need to ensure those are installed:
- `ruby` >= 2.7
- `kexec-tools`
- `initramfs-tools` (installed by default in popular distributions)

Other requirements are probably already installed, if you use recent,
mainstream Linux distribution:
- `kexec` support in the kernel
- `tmpfs` filesystem support in kernel
- `cryptsetup` (if you use disk encryption, it should be installed)
- `systemd`
- `strace` (may be skipped)

## Installation

Make sure the required software is installed, then install the gem by executing:

    $ gem install crypt_reboot

## Usage

Cryptreboot performs operations normally only available to the root user,
so it is suggested to use sudo or a similar utility.

In order to perform a reboot type:

    $ sudo cryptreboot

To see the usage, run:

    $ cryptreboot --help

## Resolutions for common issues

### LZ4 initramfs compression

If you get:

> LZ4 compression is not allowed, change the compression algorithm in
initramfs.conf and regenerate the initramfs image

it means initramfs was compressed using LZ4 algorithm, which seems to
have issues with concatenating initramfs images.

In case you are 100% sure LZ4 won't cause problems, you can use
`--skip-lz4-check` command line flag. This will make the error message
go away, but you risk automatic disk unlocking at startup to fail randomly.

Instead, the recommended approach is to change the compression algorithm
in `/etc/initramfs-tools/initramfs.conf` file. Look for `COMPRESS` and
set it to some other value such as `gzip` (the safe choice), or `zstd`
(the best compression, but your kernel and initramfs-tools need to support it).

Here is a one-liner to change compression to `gzip`:

    $ sudo sed -iE 's/^\s*COMPRESS=.*$/COMPRESS=gzip/' /etc/initramfs-tools/initramfs.conf

Then you need to regenerate all of your initramfs images:

    $ sudo update-initramfs -k all -u

That's it.

Resources related to the issue:
- [Appending files to initramfs image - reliable? (StackExchange)](https://unix.stackexchange.com/a/737219)
- [What is the correct frame format for linux (Lz4 issue)](https://github.com/lz4/lz4/issues/956)
- [Initramfs unpacking failed (Ubuntu bug report)](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1835660)

### Staged kernel not being executed by systemd

If rebooting with cryptreboot doesn't seem to differ from a standard
reboot, it may suggest staged kernel is not being executed by the
`systemd` at the end of the shutdown procedure.

The solution I found is to execute `kexec -e` instead of
`systemctl --force kexec` when the system is ready for a reboot.
In order to do that `systemd-kexec.service` has to be modified.
Let's use `systemd drop-in` for that:

    $ sudo mkdir -p /etc/systemd/system/systemd-kexec.service.d/
    $ echo -e "[Service]\nExecStart=\nExecStart=kexec -e" | sudo tee /etc/systemd/system/systemd-kexec.service.d/override.conf

That should work.

To cancel the change, remove the file:

    $ sudo rm /etc/systemd/system/systemd-kexec.service.d/override.conf

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

## License

The software is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cryptreboot project's codebases, issue
trackers, chat rooms, and mailing lists is expected to follow the
[code of conduct](https://github.com/phantom-node/cryptreboot/blob/master/CODE_OF_CONDUCT.md).
