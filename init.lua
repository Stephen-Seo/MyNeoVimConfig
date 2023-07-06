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


vim.cmd(
[[
" CJK imput
function CJKInput()
    let l:cmd = 'zenity --entry --text=CJK-Input 2>/dev/null'
    let l:output = system(l:cmd)
    let l:output = substitute(l:output, '[\r\n]*$', '', '')
    execute 'normal i' . l:output
endfunction
nmap <silent> <leader>i :call CJKInput()<CR>
]])

--vim.cmd('nmap q :echo "I accidentally hit q, I don\'t use macros"<CR>')
--vim.cmd('vmap q <ESC>:echo "I accidentally hit q, I don\'t use macros"<CR>')

vim.cmd('nmap q :lua vim.g.quickcomment_togglecommentline()<CR>')
vim.cmd('vmap q :luado vim.g.quickcomment_togglecommentline(linenr)<CR>')

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

vim.g.foldmethod_treesitter_fn = function ()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end
