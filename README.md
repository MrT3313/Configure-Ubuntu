# Ubuntu Environment Setup Scripts

## Usage

### Make Scripts Executable

```bash
make executable
```

### Run Everything
To install all applications at once:
```bash
make run
```
`make run` depends on `executable`, so it will mark the scripts executable
and then invoke `./setup-environment.sh` in one step.

### Preserve Existing Dock Favorites
By default the script wipes the GNOME dock favorites before re-pinning the
managed apps. To keep your existing favorites on a re-run:
```bash
make run-preserve-favorites
```
