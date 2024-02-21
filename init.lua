--This is free and unencumbered software released into the public domain.
--
--Anyone is free to copy, modify, publish, use, compile, sell, or
--distribute this software, either in source code form or as a compiled
--binary, for any purpose, commercial or non-commercial, and by any
--means.
--
--In jurisdictions that recognize copyright laws, the author or authors
--of this software dedicate any and all copyright interest in the
--software to the public domain. We make this dedication for the benefit
--of the public at large and to the detriment of our heirs and
--successors. We intend this dedication to be an overt act of
--relinquishment in perpetuity of all present and future rights to this
--software under copyright law.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
--MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
--IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
--OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
--ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
--OTHER DEALINGS IN THE SOFTWARE.
--
--For more information, please refer to <https://unlicense.org>

-- settings
vim.o.nu = true
-- truecolor
vim.o.termguicolors = true
-- color scheme
--vim.g.colors_name = "jellybeans"
--vim.api.nvim_command("color jellybeans")
vim.api.nvim_command("let g:dracula_colorterm = 0")
vim.api.nvim_command("color dracula")
vim.o.hlsearch = true
--vim.g.syntax = "on" -- unknown how to do this in lua, but is default on
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.colorcolumn = "80"
vim.o.scrolloff = 4
vim.o.mouse = "a"
vim.o.guifont = "JetBrainsMono 10"
vim.api.nvim_command('au BufEnter * hi ColorColumn guibg=red ctermbg=red')

-- git commit
vim.api.nvim_command('autocmd FileType gitcommit setlocal colorcolumn=50,72')

-- Allow tabs in Makefiles.
vim.api.nvim_command('autocmd FileType make,automake set noexpandtab shiftwidth=4 softtabstop=4')
-- Trailing whitespace and tabs are forbidden, so highlight them.
vim.api.nvim_command('highlight ForbiddenWhitespace ctermbg=yellow guibg=yellow')
vim.api.nvim_command('match ForbiddenWhitespace /\\s\\+$\\|\\t/')
-- Do not highlight spaces at the end of line while typing on that line.
vim.api.nvim_command('autocmd InsertEnter * match ForbiddenWhitespace /\\t\\|\\s\\+\\%#\\@<!$/')

-- Godot's GDScript (not used since using vim-godot plugin)
--vim.api.nvim_command('au BufNewFile,BufRead *.gd set noet')

-- Custom highlight group
vim.api.nvim_command('hi! CustomRedHighlight ctermbg=red guibg=red')
vim.api.nvim_command('match CustomRedHighlight /TODO/')

-- On <leader>i, open zenity textbox for gui text input
vim.cmd(
[[
" CJK input
function CJKInput()
    let l:cmd = 'zenity --entry --text=CJK-Input 2>/dev/null'
    let l:output = system(l:cmd)
    let l:output = substitute(l:output, '[\r\n]*$', '', '')
    execute 'normal i' . l:output
endfunction
nmap <silent> <leader>i :call CJKInput()<CR>
]])

-- Disable q
vim.cmd('nmap q :echo "I accidentally hit q, I don\'t use macros"<CR>')
vim.cmd('vmap q <ESC>:echo "I accidentally hit q, I don\'t use macros"<CR>')

-- Set <leader>q to comment selected line(s)
vim.cmd('nmap <leader>q :lua vim.g.quickcomment_togglecommentline()<CR>')
vim.cmd('vmap <leader>q :luado vim.g.quickcomment_togglecommentline(linenr)<CR>')

vim.g.quickcomment_whitespaceprefix = 1

require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "rust", "lua" },
    sync_install = false,
    ignore_install = { "javascript" },

    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
    },
}

-- Setup folding based on treesitter
vim.g.foldmethod_treesitter_fn = function ()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end

-- <leader>f to treesitter-fold
vim.cmd('nmap <leader>f :lua vim.g.foldmethod_treesitter_fn()<CR>')

-- <leader>l to load lsp
vim.cmd('nmap <silent> <leader>l :call loadlsp#loadlspall()<CR> :e<CR> :echo "Loaded lsp plugins"<CR>')
