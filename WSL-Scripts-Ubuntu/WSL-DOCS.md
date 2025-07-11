# WSL Command Reference

## Usage
```
wsl.exe [Argument] [Options...] [CommandLine]
```

## Arguments for Running Linux Binaries

If no command line is provided, `wsl.exe` launches the default shell.

### `--exec, -e <CommandLine>`
Execute the specified command without using the default Linux shell.

### `--shell-type <standard|login|none>`
Execute the specified command with the provided shell type.

### `--`
Pass the remaining command line as-is.

## Options

### `--cd <Directory>`
Sets the specified directory as the current working directory.
- If `~` is used, the Linux user's home path will be used
- If the path begins with a `/` character, it will be interpreted as an absolute Linux path
- Otherwise, the value must be an absolute Windows path

### `--distribution, -d <Distro>`
Run the specified distribution.

### `--user, -u <UserName>`
Run as the specified user.

### `--system`
Launches a shell for the system distribution.

## Arguments for Managing Windows Subsystem for Linux

### `--help`
Display usage information.

### `--debug-shell`
Open a WSL2 debug shell for diagnostics purposes.

### `--install [Distro] [Options...]`
Install a Windows Subsystem for Linux distribution.
For a list of valid distributions, use `wsl.exe --list --online`.

**Options:**
- `--no-launch, -n` - Do not launch the distribution after install
- `--web-download` - Download the distribution from the internet instead of the Microsoft Store
- `--no-distribution` - Only install the required optional components, does not install a distribution
- `--enable-wsl1` - Enable WSL1 support

### `--manage <Distro> <Options...>`
Changes distro specific options.

**Options:**
- `--move <Location>` - Move the distribution to a new location
- `--set-sparse, -s <true|false>` - Set the vhdx of distro to be sparse, allowing disk space to be automatically reclaimed

### `--mount <Disk>`
Attaches and mounts a physical or virtual disk in all WSL 2 distributions.

**Options:**
- `--vhd` - Specifies that `<Disk>` refers to a virtual hard disk
- `--bare` - Attach the disk to WSL2, but don't mount it
- `--name <Name>` - Mount the disk using a custom name for the mountpoint
- `--type <Type>` - Filesystem to use when mounting a disk, if not specified defaults to ext4
- `--options <Options>` - Additional mount options
- `--partition <Index>` - Index of the partition to mount, if not specified defaults to the whole disk

### `--set-default-version <Version>`
Changes the default install version for new distributions.

### `--shutdown`
Immediately terminates all running distributions and the WSL 2 lightweight utility virtual machine.

### `--status`
Show the status of Windows Subsystem for Linux.

### `--unmount [Disk]`
Unmounts and detaches a disk from all WSL2 distributions.
Unmounts and detaches all disks if called without argument.

### `--uninstall`
Uninstalls the Windows Subsystem for Linux package from this machine.

### `--update`
Update the Windows Subsystem for Linux package.

**Options:**
- `--pre-release` - Download a pre-release version if available

### `--version, -v`
Display version information.

## Arguments for Managing Distributions in Windows Subsystem for Linux

### `--export <Distro> <FileName> [Options]`
Exports the distribution to a tar file.
The filename can be `-` for stdout.

**Options:**
- `--vhd` - Specifies that the distribution should be exported as a .vhdx file

### `--import <Distro> <InstallLocation> <FileName> [Options]`
Imports the specified tar file as a new distribution.
The filename can be `-` for stdin.

**Options:**
- `--version <Version>` - Specifies the version to use for the new distribution
- `--vhd` - Specifies that the provided file is a .vhdx file, not a tar file. This operation makes a copy of the .vhdx file at the specified install location

### `--import-in-place <Distro> <FileName>`
Imports the specified .vhdx file as a new distribution.
This virtual hard disk must be formatted with the ext4 filesystem type.

### `--list, -l [Options]`
Lists distributions.

**Options:**
- `--all` - List all distributions, including distributions that are currently being installed or uninstalled
- `--running` - List only distributions that are currently running
- `--quiet, -q` - Only show distribution names
- `--verbose, -v` - Show detailed information about all distributions
- `--online, -o` - Displays a list of available distributions for install with `wsl.exe --install`

### `--set-default, -s <Distro>`
Sets the distribution as the default.

### `--set-version <Distro> <Version>`
Changes the version of the specified distribution.

### `--terminate, -t <Distro>`
Terminates the specified distribution.

### `--unregister <Distro>`
Unregisters the distribution and deletes the root filesystem.
