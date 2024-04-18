"This is free and unencumbered software released into the public domain.
"
"Anyone is free to copy, modify, publish, use, compile, sell, or
"distribute this software, either in source code form or as a compiled
"binary, for any purpose, commercial or non-commercial, and by any
"means.
"
"In jurisdictions that recognize copyright laws, the author or authors
"of this software dedicate any and all copyright interest in the
"software to the public domain. We make this dedication for the benefit
"of the public at large and to the detriment of our heirs and
"successors. We intend this dedication to be an overt act of
"relinquishment in perpetuity of all present and future rights to this
"software under copyright law.
"
"THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
"EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
"OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
"ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
"OTHER DEALINGS IN THE SOFTWARE.
"
"For more information, please refer to <https://unlicense.org>

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
    capabilities = capabilities,
    on_attach = function (client, bufnr)
        -- Use tree-sitter syntax highlighting, not lsp highlighting.
        client.server_capabilities.semanticTokensProvider = nil
    end
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
    },
    on_attach = function (client, bufnr)
        -- Use tree-sitter syntax highlighting, not lsp highlighting.
        client.server_capabilities.semanticTokensProvider = nil
    end
}
lspconfig.gdscript.setup {
    capabilities = capabilities,
    on_attach = function (client, bufnr)
        -- Use tree-sitter syntax highlighting, not lsp highlighting.
        client.server_capabilities.semanticTokensProvider = nil
    end
}
lspconfig.jedi_language_server.setup{
    capabilities = capabilities,
    on_attach = function (client, bufnr)
        -- Use tree-sitter syntax highlighting, not lsp highlighting.
        client.server_capabilities.semanticTokensProvider = nil
    end
}

-- apply available fix
vim.api.nvim_set_keymap("n", "<C-A>", "<cmd>lua vim.lsp.buf.code_action()<CR>", {noremap = true})
-- get lsp declaration
vim.api.nvim_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.declaration()<CR>", {noremap = true})
-- get lsp definition
vim.api.nvim_set_keymap("n", "<leader>d", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true})
-- get lsp references
vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = true})
-- goto next warning/error
--vim.api.nvim_set_keymap("n", "<C-N>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-N>", "<cmd>lua vim.diagnostic.goto_next()<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-P>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", {noremap = true})
-- Get diagnostic on currently selected
vim.api.nvim_set_keymap("n", "<leader>F", "<cmd>lua vim.diagnostic.open_float()<CR>", {noremap = true})

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
