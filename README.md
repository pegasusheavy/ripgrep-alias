# ripgrep-alias

A lightweight wrapper that makes ripgrep handle GNU grep's `-E` (`--extended-regexp`) flag correctly.

## The problem

GNU grep and ripgrep disagree on what `-E` means:

| Tool     | `-E` means          | Behavior                                    |
|----------|----------------------|---------------------------------------------|
| GNU grep | `--extended-regexp`  | Enables Extended Regular Expressions (ERE)  |
| ripgrep  | `--encoding`         | Sets input file encoding (e.g. `utf-8`)     |

If you're used to `grep -E 'pattern'` and switch to `rg -E 'pattern'`, ripgrep treats your pattern as an encoding name and errors out.

## The fix

ripgrep already uses ERE-equivalent regex syntax by default, so `-E` is redundant. This wrapper strips `-E` and `--extended-regexp` from the argument list and forwards everything else to `rg` untouched.

## Install

### Shell (bash, zsh, dash, POSIX sh)

```sh
curl -fsSL https://raw.githubusercontent.com/pegasusheavy/ripgrep-alias/main/install.sh | sh
```

or with wget:

```sh
wget -qO- https://raw.githubusercontent.com/pegasusheavy/ripgrep-alias/main/install.sh | sh
```

### PowerShell (5.1+, Core 7+)

```powershell
irm https://raw.githubusercontent.com/pegasusheavy/ripgrep-alias/main/install.ps1 | iex
```

### Manual

1. Clone the repo:
   ```sh
   git clone https://github.com/pegasusheavy/ripgrep-alias.git ~/.local/share/ripgrep-alias
   ```
2. Add to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):
   ```sh
   . "$HOME/.local/share/ripgrep-alias/rg.sh"
   ```
3. Restart your shell.

For PowerShell, add to `$PROFILE`:
```powershell
. "$HOME/.local/share/ripgrep-alias/rg.ps1"
```

## Usage

Use `rg` exactly as you would with GNU grep's `-E`:

```sh
rg -E 'fn\s+\w+' src/        # works — -E is silently consumed
rg 'fn\s+\w+' src/            # also works — same result
rg --encoding utf-8 'pattern'  # use --encoding for ripgrep's native flag
```

## How it works

The wrapper defines a shell function named `rg` that:

1. Iterates through the argument list
2. Removes `-E` and `--extended-regexp`
3. Calls `command rg` (the real binary) with the remaining arguments

That's it. No dependencies, no compilation, no configuration.

## Uninstall

1. Remove the source line from your shell profile
2. Delete `~/.local/share/ripgrep-alias/`

## License

MIT
