-- Verifica se o lazy.nvim está instalado
local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazy_path})
end
vim.opt.rtp:prepend(lazy_path)

require('lazy').setup({
  -- Gerenciador de Plugins
  { 'wbthomason/packer.nvim' },
  -- LSP (Language Server Protocol)
  { 'neovim/nvim-lspconfig' },
  -- Treesitter para melhor destaque de sintaxe
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  -- Autocompletar
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  -- Snippets
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
  -- File explorer
  { 'kyazdani42/nvim-tree.lua' },
  -- Status line
  { 'nvim-lualine/lualine.nvim' },
  -- Temas
  { 'catppuccin/nvim' },
  { 'gruvbox-community/gruvbox' }, -- Exemplo de outro tema, caso prefira
  -- Comentários
  { 'tpope/vim-commentary' },
  -- Fuzzy finder
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  -- Git integration
  { 'tpope/vim-fugitive' },
  -- Fechamento automático de colchetes, chaves e parênteses
  { 'windwp/nvim-autopairs' },
  -- Suporte para Markdown
  { 'plasticboy/vim-markdown' },
  { 'akinsho/toggleterm.nvim', version = "*", config = true },
})

require("toggleterm").setup{
  size = 20,
  open_mapping = [[<F5>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = true,
  shell = 'pwsh',
  float_opts = {
    border = 'curved',
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  }
}

vim.cmd [[
  colorscheme catppuccin
]]

require("catppuccin").setup({
  flavour = "auto",
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false,
  show_end_of_buffer = false,
  -- outras opções de configuração conforme sua preferência
})

-- Configurações gerais
vim.o.number = true
vim.o.relativenumber = false
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.api.nvim_set_keymap('n', 'a', 'i', { noremap = true }) -- Modo insert na frente precionando i
vim.api.nvim_set_keymap('n', 'i', 'a', { noremap = true }) -- Modo insert no inicio precionando a
vim.api.nvim_set_keymap('i', 'sys', 'System.out.println("");<Esc>i', { noremap = true })-- Mapeamento para digitar sys e completar com System.out.println("");
vim.api.nvim_set_keymap('i', '<C-x>', '<Esc>:wq<CR>', { noremap = true }) -- Mapeamento para salvar e sair do Neovim ao pressionar CTRL+X no modo insert e normal
vim.api.nvim_set_keymap('n', '<C-x>', ':wq<CR>', { noremap = true })  -- Mapeamento para salvar e sair do Neovim ao pressionar CTRL+X no modo insert e normal
vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true }) -- Configuração para abrir o nvim-tree com CTRL+B
vim.api.nvim_set_keymap('i', '<Esc>', '<Esc>:w<CR>', { noremap = true, silent = true })-- Mapeamento para salvar automaticamente ao sair do modo visual
vim.api.nvim_set_keymap('n', '<C-a>','ggVG',{ noremap = true }) -- Mapeamento para selecionar todo o texto ao precionar
vim.api.nvim_set_keymap('n', 'z', '<Cmd>undo<CR>', { noremap = true })-- Atalho para desfazer as últimas ações ao pressionar 'z'
vim.api.nvim_set_keymap('n', 'r', '<Cmd>redo<CR>', { noremap = true })-- Atalho para refazer a última ação ao pressionar 'r'
require('nvim-tree').setup{} -- Configuração do nvim-tree
require('nvim-autopairs').setup{} -- Configurações do nvim-autopairs

-- Configurações do nvim-cmp
local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline('?', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Configurações LSP (exemplo com Python e Java)
-- local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
end

-- Capabilities para o nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Configuração do Neovim para usar win32yank no Windows
if vim.fn.has('win32') then
  vim.opt.clipboard:append({ 'unnamedplus' })
  vim.fn.setenv('WING32YANK_CLIPBOARD', '1')
end

-- Desativa a criação de arquivos swap
vim.o.swapfile = false

-- Função para alternar o terminal
function _G.toggle_terminal()
  local term_buf = vim.fn.bufnr('term://*')
  if term_buf ~= -1 then
    -- Se o terminal estiver aberto, feche-o
    vim.api.nvim_buf_delete(term_buf, { force = true })
  else
    -- Caso contrário, abra um novo terminal e entre no modo de inserção
    vim.cmd('term pwsh')
    vim.cmd('startinsert')
  end
end

-- Mapeamento para alternar o terminal ao pressionar F4
vim.api.nvim_set_keymap('n', '<C-t>', ':lua toggle_terminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-t>', '<C-\\><C-n>:lua toggle_terminal()<CR>', { noremap = true, silent = true })
