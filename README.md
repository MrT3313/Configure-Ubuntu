# Environment Setup Scripts

This directory contains modular installation scripts for setting up a development environment on Ubuntu 22.04.

## Structure

```
setup-environment.sh          # Main orchestration script (run this)
configuration/                # Directory containing individual installation modules
├── 01-system-update.sh       # Updates package lists
├── 02-prerequisites.sh       # Installs common dependencies
├── 03-install-chromium.sh    # Installs Chromium Browser
├── 04-install-vscode.sh      # Installs Visual Studio Code
├── 05-install-cursor.sh      # Installs Cursor AI editor
└── 06-final-update.sh        # Final system update
```

## Usage

### Make Scripts Executable

```bash
chmod +x setup-environment.sh configuration/*.sh
```

### Run Everything
To install all applications at once:
```bash
./setup-environment.sh
```

### Run Individual Modules
You can run individual installation modules if you only want specific applications:

```bash
# Install only Chromium
./configuration/01-system-update.sh
./configuration/02-prerequisites.sh
./configuration/03-install-chromium.sh

# Install only VS Code
./configuration/01-system-update.sh
./configuration/02-prerequisites.sh
./configuration/04-install-vscode.sh

# Install only Cursor
./configuration/01-system-update.sh
./configuration/02-prerequisites.sh
./configuration/05-install-cursor.sh
```

## Customization

### Adding New Applications
To add a new application to the setup:

1. Create a new script in the `configuration/` directory (e.g., `07-install-myapp.sh`)
2. Follow the existing script format with detailed comments
3. Add a call to `run_module "07-install-myapp.sh"` in the main `setup-environment.sh` script
4. Make the script executable: `chmod +x configuration/07-install-myapp.sh`

### Removing Applications
To skip installing certain applications:

1. Comment out or remove the corresponding `run_module` call in `setup-environment.sh`
2. Or simply delete the module script from the `configuration/` directory

### Modifying Existing Installations
Each module is self-contained, so you can:
- Edit individual scripts without affecting others
- Change installation methods (e.g., use snap instead of apt)
- Add custom configuration steps
- Include additional packages

## Architecture Support

All scripts support both x86_64 and ARM64 architectures:
- **Chromium**: Native support for both architectures
- **VS Code**: Native support for both architectures (Microsoft provides ARM64 builds)
- **Cursor**: Native support for both architectures (separate AppImages for each)

The scripts automatically detect your system architecture and download the appropriate version.

## Benefits of Modular Design

1. **Easy Maintenance**: Update individual applications without touching others
2. **Selective Installation**: Run only the modules you need
3. **Reusability**: Share individual modules across different setups
4. **Debugging**: Easier to identify and fix issues in specific modules
5. **Extensibility**: Simply add new modules to expand functionality
6. **Version Control**: Track changes to specific installations independently

## Storage Location

It's recommended to store this entire directory structure on your base Ubuntu 22.04 Desktop:

```bash
# Good locations:
~/scripts/environment-setup/
~/Documents/setup-scripts/
/opt/setup-scripts/  # If you want system-wide access
```

This way, you can:
- Reuse the scripts after system updates or reinstalls
- Version control with git
- Share with other users or systems
- Keep your base system configuration organized

## Notes

- All scripts require sudo privileges for package installation
- Scripts use `set -e` to exit immediately if any command fails
- The main script validates that the `configuration/` directory exists
- Each module includes detailed comments explaining what it does
- Scripts check if applications are already installed before reinstalling
