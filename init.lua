-- Set a leader key
vim.keymap.set('',' ', '<Nop>')
vim.g.mapleader = ' '
-- Make it easier to make it easier to edit text (quickedit vimrc)
vim.keymap.set('n', '<leader>svim', '<cmd>source $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>evim', '<cmd>vsplit $MYVIMRC<cr>')

-- Exit insert mode easily
vim.keymap.set('i', 'jk', '<esc>')

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indenting
vim.opt.shiftround = true
vim.opt.shiftwidth = 4

-- Mouse
vim.opt.mouse = 'a'

-- Search words
vim.opt.hls = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set('n', '<leader>/', '<cmd>noh<cr>')

-- Key binds
------------
vim.keymap.set('i', '<c-u>', '<esc>viwUea')
vim.keymap.set('n', '<c-u>', 'viwUea<esc>')

-- Splits
vim.keymap.set('n', '<leader>ww', '<c-w>w')
vim.keymap.set('n', '<leader>wc', '<c-w>c')
vim.keymap.set('n', '<leader>wn', '<c-w>n')

-- Lazy Package Manager
local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  -- You can "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)
  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
    {'nvim-tree/nvim-web-devicons'},
    {'folke/tokyonight.nvim'},
    {'nvim-lualine/lualine.nvim'},
    {'akinsho/bufferline.nvim', version = "v3.*", dependencies = 'nvim-tree/nvim-web-devicons'},
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {'numToStr/Comment.nvim'},
    {'kylechui/nvim-surround', version='*', event= 'VeryLazy'},
    {'nvim-tree/nvim-tree.lua', version='*'},
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/nvim-cmp', dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-path','hrsh7th/cmp-buffer'},},
    {'rafamadriz/friendly-snippets'}
})
----------
-- Plugins
----------

-- Theme
vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

-- Lualine
vim.opt.showmode = false
require('lualine').setup({
    options = {
        theme = 'onedark',
        icons_enabled = false,
        component_separators = '|',
        section_separators = '',
        disabled_filetypes = {
            statusline = {'NvimTree'},
        }
    }
})

-- Bufferline
require('bufferline').setup({
    options = {
        mode = 'buffers',
        offsets = {
            {filetype = 'NvimTree'}
        },
    },
    highlights = {
        buffer_selected = {
            italic = false
        },
        indicator_selected = {
            fg = {attribute = 'fg', highlight = 'Function'},
            italic = false
        }
    }
})

-- Treesitter
require('nvim-treesitter.configs').setup({
    highlights = {
        enable = true,
    },
    ensure_installed = {
        'python',
        'json',
        'lua',
        'rust',
    }
})

-- Comments
require('Comment').setup({})

-- Nvim surround
require('nvim-surround').setup({})

-- Nvim tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('nvim-tree').setup({})
vim.keymap.set('n','<leader>tt','<cmd>NvimTreeToggle<cr>')
vim.keymap.set('n','<leader>tc','<cmd>NvimTreeCollapse<cr>')

-- Toggleterm
require('toggleterm').setup({
    open_mapping = '<C-h>',
    direction = 'horizontal',
    shade_terminals = true,
})
vim.keymap.set('t', 'jk', '<C-\\><C-n>')

-- LSPs
----------

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

---
-- LSP Servers
---
-- https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/

local lsp_servers = { "pyright", }
for _, nvim_lsp in ipairs(lsp_servers) do
    lspconfig[nvim_lsp].setup({})
end

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})


-- Snippets
-----------

require('luasnip.loaders.from_vscode').lazy_load()

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

local cmp = require('cmp')
local luasnip = require('luasnip')


luasnip.config.setup({})

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['C-y>'] = cmp.mapping.complete({
            reason = cmp.ContextReason.Auto,
        }),
        ['<C-e>'] = cmp.mapping.close(),
        ['<Tab>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
    },
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp', keyword_length = 1},
        { name = 'buffer', keyword_length = 3},
        { name = 'luasnip', keyword_length = 2},
    },
    window = {
        documentation = cmp.config.window.bordered()
    },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                luasnip = '⋗',
                buffer = 'Ω',
                path = '🖫',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})