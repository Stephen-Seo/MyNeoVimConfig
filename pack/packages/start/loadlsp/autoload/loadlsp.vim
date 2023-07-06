function! loadlsp#loadlspall()

if exists("g:loadlspall_loaded") && g:loadlspall_loaded == 1
    echo "Already loaded"
    return
else
    let g:loadlspall_loaded = 1
endif

let l:lsppack_path = "/.config/nvim/lsppack"

let &packpath = &packpath
\   . "," . environ()["HOME"]
\   . l:lsppack_path

packloadall!

" lsp

"set completeopt=menu,menuone,noselect

lua <<EOF
local lspconfig = require'lspconfig'
local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 's' }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }
    }, {
        { name = 'buffer' },
    })
})

cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.clangd.setup {
    cmd = {"clangd", "--completion-style=detailed"},
    capabilities = capabilities
}

local rust_features = {}

if string.find(vim.fn.getcwd(), "git/mpd_info_screen") then
    table.insert(rust_features, "unicode_support")
end

lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            ["cargo"] = {
                ["features"] = rust_features,
            },
        },
    }
}
lspconfig.gdscript.setup {
    capabilities = capabilities
}
lspconfig.jedi_language_server.setup{
    capabilities = capabilities
}

-- apply available fix
vim.api.nvim_set_keymap("n", "<C-F>", "<cmd>lua vim.lsp.buf.code_action()<CR>", {noremap = true})
-- goto next warning/error
--vim.api.nvim_set_keymap("n", "<C-N>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-N>", "<cmd>lua vim.diagnostic.goto_next()<CR>", {noremap = true})

EOF

" init after/ sources
let after_scripts = glob(environ()["HOME"] . l:lsppack_path . "/pack/*/start/*/after/**", 0, 1)
for item in after_scripts
    if item =~ ".*\.lua$" || item =~ ".*\.vim$"
        execute 'source' item
    endif
endfor

echo 'loaded lsp plugins'

endfunction
