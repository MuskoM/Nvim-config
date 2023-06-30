-- [[
-- This is a PDE created by myself inspired by Kickstart.vim  
--]]

vim.keymap.set('',' ', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader= ' '

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system{
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end

vim.opt.rtp:prepend(lazypath)

-- INSTALL PLUGINS HERE
-- Tip: use config key to configure the plugin

require('lazy').setup({
    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    -- LSP related plugins
    {
        -- LSP config & plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true},
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- Note: `opts = {}` is equivalent to `require('fidget').setup({})`
            {'j-hui/fidget.nvim', tag = 'legacy', opts = {}},

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Add LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },

    -- Useful plugin to show you pending keybinds
    {'folke/which-key.nvim', opts = {}},
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See: `help gitsigns.txt`
            signs = {
                add = {text='+'},
                change = {text='~'},
                delete = {text='_'},
                topdelete = {text='‾'},
                changedelete = {text='~'},
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
                vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
            end,
        },
    },

    {
        -- Theme - Tokyonight
        'folke/tokyonight.nvim',
        priority = 1000,
        config = function()
            vim.opt.termguicolors = true
            vim.cmd.colorscheme = 'tokyonight'
        end,
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                theme = 'tokyonight',
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        },
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    -- Fuzzy Finder (files, lsp, etc)
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end,
    },

    {
        -- Hightlight edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },

    -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    You can use this folder to prevent any conflicts with this init.lua 
    --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
    {import = 'custom.plugins'},

}, {})

-- [[ Settings options ]]

vim.o.hlsearch = false

vim.wo.number = true

vim.o.mouse = 'a'

vim.o.clipboard = 'unnamedplus'

vim.o.breakindent = true

vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indenting
vim.opt.shiftround = true
vim.opt.shiftwidth = 4

-- [[ Basic keymaps ]]

-- Exit insert mode easily
vim.keymap.set('i', 'jk', '<esc>')

-- To uppercase from insert and visual mode
vim.keymap.set('i', '<c-u>', '<esc>viwUea')
vim.keymap.set('n', '<c-u>', 'viwUea<esc>')

-- Splits
vim.keymap.set('n', '<leader>ww', '<c-w>w')
vim.keymap.set('n', '<leader>wc', '<c-w>c')
vim.keymap.set('n', '<leader>wn', '<c-w>n')

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-------OLD STUFF
-- -- Set a leader key

-- -- Make it easier to make it easier to edit text (quickedit vimrc)
-- vim.keymap.set('n', '<leader>svim', '<cmd>source $MYVIMRC<cr>')
-- vim.keymap.set('n', '<leader>evim', '<cmd>vsplit $MYVIMRC<cr>')

-- Exit insert mode easily
vim.keymap.set('i', 'jk', '<esc>')

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indenting
vim.opt.shiftround = true
vim.opt.shiftwidth = 4

-- -- Mouse
-- vim.opt.mouse = 'a'

-- -- Search words
-- vim.opt.hls = true
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true
-- vim.keymap.set('n', '<leader>/', '<cmd>noh<cr>')

-- -- Key binds
-- ------------
vim.keymap.set('i', '<c-u>', '<esc>viwUea')
vim.keymap.set('n', '<c-u>', 'viwUea<esc>')

-- Splits
vim.keymap.set('n', '<leader>ww', '<c-w>w')
vim.keymap.set('n', '<leader>wc', '<c-w>c')
vim.keymap.set('n', '<leader>wn', '<c-w>n')

-- -- Lazy Package Manager
-- local lazy = {}

-- function lazy.install(path)
--   if not vim.loop.fs_stat(path) then
--     print('Installing lazy.nvim....')
--     vim.fn.system({
--       'git',
--       'clone',
--       '--filter=blob:none',
--       'https://github.com/folke/lazy.nvim.git',
--       '--branch=stable', -- latest stable release
--       path,
--     })
--   end
-- end

-- function lazy.setup(plugins)
--   -- You can "comment out" the line below after lazy.nvim is installed
--   lazy.install(lazy.path)

--   vim.opt.rtp:prepend(lazy.path)
--   require('lazy').setup(plugins, lazy.opts)
-- end

-- lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- lazy.opts = {}

-- lazy.setup({
--     {'nvim-tree/nvim-web-devicons'},
    -- {'folke/tokyonight.nvim'},
--     {'nvim-lualine/lualine.nvim'},
--     {'akinsho/bufferline.nvim', version = "v3.*", dependencies = 'nvim-tree/nvim-web-devicons'},
--     {'akinsho/toggleterm.nvim', version = "*", config = true},
--     {'numToStr/Comment.nvim'},
--     {'kylechui/nvim-surround', version='*', event= 'VeryLazy'},
--     {'nvim-tree/nvim-tree.lua', version='*'},
--     {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
--     {'neovim/nvim-lspconfig'},
--     {'hrsh7th/nvim-cmp', dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-path','hrsh7th/cmp-buffer'},},
--     {'rafamadriz/friendly-snippets'}
-- })
-- ----------
-- -- Plugins
-- ----------

-- -- Theme
-- vim.opt.termguicolors = true
-- vim.cmd.colorscheme('tokyonight')

-- -- Lualine
-- vim.opt.showmode = false
-- require('lualine').setup({
--     options = {
--         theme = 'onedark',
--         icons_enabled = false,
--         component_separators = '|',
--         section_separators = '',
--         disabled_filetypes = {
--             statusline = {'NvimTree'},
--         }
--     }
-- })

-- -- Bufferline
-- require('bufferline').setup({
--     options = {
--         mode = 'buffers',
--         offsets = {
--             {filetype = 'NvimTree'}
--         },
--     },
--     highlights = {
--         buffer_selected = {
--             italic = false
--         },
--         indicator_selected = {
--             fg = {attribute = 'fg', highlight = 'Function'},
--             italic = false
--         }
--     }
-- })

-- -- Treesitter
-- require('nvim-treesitter.configs').setup({
--     highlights = {
--         enable = true,
--     },
--     ensure_installed = {
--         'python',
--         'json',
--         'lua',
--         'rust',
--     }
-- })

-- -- Comments
-- require('Comment').setup({})

-- -- Nvim surround
-- require('nvim-surround').setup({})

-- -- Nvim tree
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- require('nvim-tree').setup({})
-- vim.keymap.set('n','<leader>tt','<cmd>NvimTreeToggle<cr>')
-- vim.keymap.set('n','<leader>tc','<cmd>NvimTreeCollapse<cr>')

-- -- Toggleterm
-- require('toggleterm').setup({
--     open_mapping = '<C-h>',
--     direction = 'horizontal',
--     shade_terminals = true,
-- })
-- vim.keymap.set('t', 'jk', '<C-\\><C-n>')

-- -- LSPs
-- ----------

-- local lspconfig = require('lspconfig')
-- local lsp_defaults = lspconfig.util.default_config

-- lsp_defaults.capabilities = vim.tbl_deep_extend(
--     'force',
--     lsp_defaults.capabilities,
--     require('cmp_nvim_lsp').default_capabilities()
-- )

-- ---
-- -- LSP Servers
-- ---
-- -- https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/

-- local lsp_servers = { "pyright", }
-- for _, nvim_lsp in ipairs(lsp_servers) do
--     lspconfig[nvim_lsp].setup({})
-- end

-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--   callback = function(ev)
--     -- Enable completion triggered by <c-x><c-o>
--     vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
--     -- Buffer local mappings.
--     -- See `:help vim.lsp.*` for documentation on any of the below functions
--     local opts = { buffer = ev.buf }
--     vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--     vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--     vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
--     vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
--     vim.keymap.set('n', '<leader>wl', function()
--       print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--     end, opts)
--     vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
--     vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
--     vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
--     vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--     vim.keymap.set('n', '<leader>f', function()
--       vim.lsp.buf.format { async = true }
--     end, opts)
--   end,
-- })


-- -- Snippets
-- -----------

-- require('luasnip.loaders.from_vscode').lazy_load()

-- vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- local cmp = require('cmp')
-- local luasnip = require('luasnip')


-- luasnip.config.setup({})

-- cmp.setup({
--     snippet = {
--         expand = function(args)
--             luasnip.lsp_expand(args.body)
--         end,
--     },
--     mapping = cmp.mapping.preset.insert {
--         ['C-y>'] = cmp.mapping.complete({
--             reason = cmp.ContextReason.Auto,
--         }),
--         ['<C-e>'] = cmp.mapping.close(),
--         ['<Tab>'] = cmp.mapping.confirm({
--             behavior = cmp.ConfirmBehavior.Insert,
--             select = true,
--         }),
--         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--         ['<C-n>'] = cmp.mapping.select_next_item(),
--         ['<C-p>'] = cmp.mapping.select_prev_item(),
--     },
--     sources = {
--         { name = 'path' },
--         { name = 'nvim_lsp', keyword_length = 1},
--         { name = 'buffer', keyword_length = 3},
--         { name = 'luasnip', keyword_length = 2},
--     },
--     window = {
--         documentation = cmp.config.window.bordered()
--     },
--     formatting = {
--         fields = {'menu', 'abbr', 'kind'},
--         format = function(entry, item)
--             local menu_icon = {
--                 nvim_lsp = 'λ',
--                 luasnip = '⋗',
--                 buffer = 'Ω',
--                 path = '🖫',
--             }
--             item.menu = menu_icon[entry.source.name]
--             return item
--         end,
--     },
-- })