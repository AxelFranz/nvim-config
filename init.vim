"All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" everytime an upgrade of the vim packages is performed.  It is recommended to
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim80/vimrc_example.vim or the vim manual
" and configure vim to your own liking! do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1
call plug#begin()
" DEPENDENCY FOR A LOT OF PLUGINS
Plug 'kyazdani42/nvim-web-devicons'

" DEPENDENCY TOO
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Multicursor // Not set up yet
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Autoclose tag
Plug 'alvan/vim-closetag'

" Preview hex colors
Plug 'ap/vim-css-color'

" Autoclose parenthesis,...
Plug 'jiangmiao/auto-pairs'

" Idk i don't remember but smh i'll keep it
Plug 'ctrlpvim/ctrlp.vim'

" Bottom line config
Plug 'nvim-lualine/lualine.nvim'

" Plugin library (everything is set up in the lua part)
Plug 'echasnovski/mini.nvim'

" Visual theme
Plug 'EdenEast/nightfox.nvim'
Plug 'cocopon/iceberg.vim'
Plug 'NTBBloodbath/doom-one.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" File explorer
Plug 'nvim-tree/nvim-tree.lua'

" HTML tools
Plug 'mattn/webapi-vim'
Plug 'mattn/emmet-vim'

" Markdown tools
Plug 'ixru/nvim-markdown'

" LSP config // Not used
Plug 'williamboman/mason.nvim' 
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" Beautify with :Beautify
Plug 'zeekay/vim-beautify'

Plug 'nvim-lua/plenary.nvim'
Plug 'AntonVanAssche/md-headers.nvim'


Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

call plug#end()

" Remap Leader to space
map <Space> <Leader>

" Remove whitespace
nmap <Space>r :%s/\s\+$//e<Enter>

nnoremap <Leader><Enter> :MarkdownHeaders<Enter>

" Change to your language

" For CTRL T/D in visual
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" copy and paste
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" Move lines no matter the mode
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Markdown previw on ctrl p
nnoremap <Leader>s :MarkdownPreviewToggle<Enter>

" Emmet Config
let g:user_emmet_leader_key='<Leader>'
let g:user_emmet_install_global = 0
autocmd FileType html,css,javascript,php EmmetInstall

" Change next line if you're not french :) 
let g:user_emmet_settings = {
\  'variables': {'lang': 'fr'},
\  'html': {
\    'default_attributes': {
\      'option': {'value': v:null},
\      'textarea': {'id': v:null, 'name': v:null, 'cols': 10, 'rows': 10},
\    },
\    'snippets': {
\      'html:5': "<!DOCTYPE html>\n"
\              ."<html lang=\"${lang}\">\n"
\              ."<head>\n"
\              ."\t<meta charset=\"${charset}\">\n"
\              ."\t<title></title>\n"
\              ."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
\              ."</head>\n"
\              ."<body>\n\t${child}|\n</body>\n"
\              ."</html>",
\    },
\  },
\}

" File-dependent plugin enabling
autocmd BufNewFile,BufRead *.pl set filetype=prolog
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" For number lines
set number relativenumber
set nu rnu

" Syntax highlighting
syntax on

" Clear hightlighting
nmap <F3> :noh<Enter>

" ; in normal adds ; at the end of the line
nmap ; A;<Esc>

" Add Lines without leaving normal mode
nnoremap <Leader>o o<Esc>0"_D
nnoremap <Leader>O O<Esc>0"_D

" File explorer remap
nmap <Leader>e <cmd>NvimTreeToggle<cr>

" Tab fixing
set autoindent
set expandtab
set tabstop=4
set softtabstop=2
set shiftwidth=4

" Enabling the theme
colorscheme nordfox

" Lua File
lua << EOF
local theme = require('lualine.themes.auto')


require('lualine').setup({
  options = {
	theme = theme, -- Supprimmer cette ligne si tu veux pas changer le thème
    component_separators = '',
    section_separators = { left = '', right = '' },
    sections = {
  },
	lualine_a = {'mode'},
	lualine_b = {'filename','filesize'},
	lualine_c = {'branch'},
	lualine_x = {'diagnostics'},
	lualine_y = {'location'},
	lualine_z = {'fileformat','filetype'},
  },
}
)
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      }
   },
  },
  ensure_installed = {
    --- parsers....
  },
})

require('mini.comment').setup()
require('mini.completion').setup()
require('mini.cursorword').setup()
require('nvim-tree').setup({
  hijack_cursor = true,
  on_attach = function(bufnr)
    local bufmap = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, {buffer = bufnr, desc = desc})
    end

    -- See :help nvim-tree.api
    local api = require('nvim-tree.api')
   
    bufmap('L', api.node.open.edit, 'Expand folder or go to file')
    bufmap('H', api.node.navigate.parent_close, 'Close parent folder')
    bufmap('gh', api.tree.toggle_hidden_filter, 'Toggle hidden files')
  end
})
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {"clangd"},
  automatic_installation = true
})

require("mason-lspconfig").setup_handlers {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function (server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {}
	end,
}

local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.emmet_ls.setup({
    -- on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
    init_options = {
      html = {
        options = {
          -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
          ["bem.enabled"] = true,
        },
      },
    }
})


EOF
