# My NeoVim Config

This is just a dump of my NVim config.

## Things to note before using

Normal mode "q" (macro shortcut) is disabled by default. If you want to enable
use of this shortcut, you can disable it in the `init.lua` config file.

## Installing This Config

1. Clone the repo into `$HOME/.config/nvim`.  
2. Invoke `git submodule update --init --recursive` in
   `$HOME/.config/nvim`.

## Updating This Config

1. `git pull` or `git fetch` and merge.
2. `git submodule update --init --recursive`
3. Open nvim and invoke `:TSUpdate` to update tree-sitter.

## Enabling LSP

In NeoVim, ~~invoke `:call loadlsp#loadlspall()`, then reload the current open
files with `:e`~~ use the `<leader>l` (backslash and l) shortcut and LSP
functionality will be enabled for the currently open file. If you have more
than one buffer open, you may have to reopen them (with :e) for lsp plugins to
take effect.

`loadlsp#loadlspall()` is a custom function that can be found
[here](https://git.seodisparate.com/stephenseo/MyNeoVimConfig/src/branch/main/pack/packages/start/loadlsp/autoload/loadlsp.vim).

## Other Notes

You can view currently registered normal-mode shortcuts with `:nmap`.

If you want to improve/support/file-an-issue about this config, send it to:

stephen AT seodisparate DOT com
