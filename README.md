# My NeoVim Config

This is just a dump of my NVim config.

## Using This Config

1. Clone the repo into `$HOME/.config/nvim`.  
2. Invoke `git sumbodule update --init --recursive --depth=1` in
   `$HOME/.config/nvim`.

## Enabling LSP

In NeoVim, invoke `:call loadlsp#loadlspall()`, then reload the current open
files with `:e` and LSP functionality will be enabled for the currently open
files.
