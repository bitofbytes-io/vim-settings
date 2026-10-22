# Vim settings

A small Vim configuration with the bundled Monokai colorscheme, line numbers,
100-column text wrapping, spell checking, incremental case-smart search,
matching-bracket highlighting, and 1,000 undo levels. Indentation defaults to
four spaces (`tabstop`, `softtabstop`, and `shiftwidth` are 4 with `expandtab`).
Filetype plugins and indentation scripts can override defaults for formats such
as Makefiles, where literal tabs are required.

## Requirements

Use Vim 8.0 or newer with syntax support; validation runs on Vim 9.x. A truecolor
terminal is recommended for the theme's GUI colors. When supported by Vim,
`termguicolors` is enabled automatically in GUI Vim or when `COLORTERM` is
`truecolor` or `24bit`. Otherwise, its existing value is preserved; a fresh
terminal session uses the theme's 256-color palette. To override detection,
set `let g:vim_settings_truecolor = 1` (enable) or `0` (disable) before sourcing
this config, for example with `vim --cmd 'let g:vim_settings_truecolor = 1'`.
If Monokai is missing, Vim starts with its default colorscheme. No plugin
manager is required.

## Install

Clone into a separate configuration checkout:

```sh
git clone https://github.com/bitofbytes-io/vim-settings.git "$HOME/.config/vim-settings"
```

Back up existing files or symlinks before linking. These commands preserve
`~/.vimrc` and the entire existing colors directory in a unique backup directory:

```sh
config="$HOME/.config/vim-settings"
backup=$(mktemp -d "$HOME/vim-backup.XXXXXX")
mkdir -p "$HOME/.vim"
if [ -e "$HOME/.vimrc" ] || [ -L "$HOME/.vimrc" ]; then
  mv "$HOME/.vimrc" "$backup/vimrc"
fi
if [ -e "$HOME/.vim/colors" ] || [ -L "$HOME/.vim/colors" ]; then
  mv "$HOME/.vim/colors" "$backup/colors"
fi
ln -s "$config/.vimrc" "$HOME/.vimrc"
ln -s "$config/colors" "$HOME/.vim/colors"
printf 'Previous configuration saved in %s\n' "$backup"
```

Start `vim`, or reload with `:source ~/.vimrc`. Use `:set paste` temporarily
when pasting in terminals without bracketed paste, and `:set nopaste` afterward.
The colorscheme attribution, verified upstream source, and MIT license are in [NOTICE.md](NOTICE.md).

## Update and test

Run `git -C "$HOME/.config/vim-settings" pull --ff-only`, then restart Vim.
Review local changes before updating; the symlinks automatically use the updated
files. Runtime history, swap, backup, and undo files are ignored by Git.

Run `sh tests/smoke.sh` from this checkout. The test uses a temporary HOME and
explicit runtime path, loads the configuration with and without the theme,
checks truecolor advertisement, overrides, and existing settings, asserts
indentation/search settings and filetype support (including literal tabs in
Make recipes), and checks ignore patterns. It never sources your personal Vim
configuration.

Contributions and suggestions are welcome via pull request.
