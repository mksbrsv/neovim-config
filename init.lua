vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
-- vim.opt.cursorcolumn = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.splitbelow = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.8',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        {
            'nvim-treesitter/nvim-treesitter'
        },
        {
            'nvim-treesitter/nvim-treesitter-textobjects'
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },
        {
            'p00f/clangd_extensions.nvim'
        },
        {
            'ray-x/lsp_signature.nvim',
            event = "VeryLazy",
            opts = {},
        },
        {
            'shaunsingh/nord.nvim'
        },
        {
            'catppuccin/nvim', name = 'catpuccin', priority = 1000
        },
        {
            'rose-pine/neovim', name = 'rose-pine'
        },
        {
            'echasnovski/mini.icons',
            version = false
        },
        {
            'nvim-tree/nvim-tree.lua'
        },
        {
            'numToStr/Comment.nvim'
        },
        {
            'unblevable/quick-scope'
        },
        {
            'woosaaahh/sj.nvim'
        },

        {
            'tpope/vim-surround'
        },
        {
            'windwp/nvim-autopairs',
            opts = {}
        },
        { 'neovim/nvim-lspconfig' },
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },

        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'folke/which-key.nvim' }

    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    -- install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})

--local function nvim_tree_attach(bufnr)
--    local api = require "nvim-tree.api"
--    local function opts(desc)
--        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait}
--    end
--    api.config.mappings.default_on_attach(bufnr)
--    vim.keymap.set('n', '<C-b>', api.tree.toggle(), opts("Toggle"))
--end

require("nvim-tree").setup({
    view = {
        width = 50,
    },
    --    on_attach = nvim_tree_attach,
})

require("Comment").setup()

vim.keymap.set('n', '<leader>zz', '<cmd>NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>zx', '<cmd>NvimTreeFocus<cr>')

vim.keymap.set({ 'n', 't' }, '<C-h>', '<C-w>h')
vim.keymap.set({ 'n', 't' }, '<C-j>', '<C-w>j')
vim.keymap.set({ 'n', 't' }, '<C-k>', '<C-w>k')
vim.keymap.set({ 'n', 't' }, '<C-l>', '<C-w>l')

require("clangd_extensions").setup()

require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = 'rose-pine'
    }
})
require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
    },
    ensure_installed = {
        "c",
        "lua",
        "cpp",
        "markdown",
        "markdown_inline",
        "luadoc",
        "vim",
        "vimdoc"
    },
})

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=false<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")

local sj = require("sj")
sj.setup()
vim.keymap.set("n", "s", sj.run)
vim.keymap.set("n", "<C-m>", sj.next_match)


require("rose-pine").setup({
    variant = "main",
    dark_variant = "main",
    styles = {
        bold = true,
        italic = false,
        transparency = false,
    }
})

vim.cmd.colorscheme("rose-pine")

require("telescope").load_extension("fzf")

require("telescope").setup({
    defaults = {
        file_ingore_patterns = {
            ".git",
            "build",
        },
    },
})

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local cmp = require("cmp")
local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = "path" },
        { name = "nvim_lsp", max_item_count = 10 },
        { name = "buffer",   keyword_length = 1 }
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = "[LSP]",
                buffer = "[BUF]",
                path = "[PATH]",
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
        ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),

        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping.confirm({ select = false }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
})

local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilites = vim.tbl_deep_extend("force", lsp_defaults.capabilities,
    require("cmp_nvim_lsp").default_capabilities())

local sign = function(opts)
    -- See :help sign_define()
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
    })
end

sign({ name = "DiagnosticSignError", text = "E" })
sign({ name = "DiagnosticSignWarn", text = "W" })
sign({ name = "DiagnosticSignHint", text = "H" })
sign({ name = "DiagnosticSignInfo", text = "I" })

-- See :help vim.diagnostic.config()
vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "always",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.HINT] = "H",
            [vim.diagnostic.severity.HINT] = "I",
        }
    }
})


vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

---
-- LSP Keybindings
---
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local bufnr = event.buf

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- You can search each function in the help page.
        -- For example :help vim.lsp.buf.hover()
        --
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = event.buf,
            callback = function()
                vim.lsp.buf.format({ bufnr = event.buf, id = client.id })
            end,
        })

        require("lsp_signature").on_attach({
            bind = true,
            handler_opts = {
                border = "rounded",
            },
        }, bufnr)

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")            -- show documentation
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")      -- go to definition
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")     -- go to declaration
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")  -- go to implementation
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>") -- go to type_definition
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")      -- go to references
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>")  -- show signature_help
        vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")   -- show diagnostics
        vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")    -- go to previous diagnostic
        vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")    -- go to next diagnostic
    end,
})

---
-- LSP servers
---
-- See :help mason-settings
require("mason").setup({ -- setup mason
    ui = { border = "rounded" },
})

-- require("mason-lspconfig").setup({
--     ensure_installed = {
--         "clangd",
--         "lua_ls"
--     },
--     handlers = {
--         function(server)
--             lspconfig[server].setup({})
--         end,
--     }
-- })

lspconfig.clangd.setup({
    on_attach = on_attach,
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
    init_options = {
        fallbackFlags = { '-std=c++20' }
    },
    single_file_support = false,
})

lspconfig.lua_ls.setup({
    on_attach = on_attach,

})
