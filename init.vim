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

" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim80/vimrc_example.vim or the vim manual
" and configure vim to your own liking! do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1
call plug#begin()

" Plugin pour les multicurseurs
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Fermer automatiquement les tag xml/html
Plug 'alvan/vim-closetag'

" Preview des couleurs en hexadecimal quand on fait du CSS
Plug 'ap/vim-css-color'

" Ferme automatiquement les parenthèses et autres
Plug 'jiangmiao/auto-pairs'

" Pour changer de buffers rapidement mais en vrai osef
Plug 'ctrlpvim/ctrlp.vim'

" La barre du bas en joli
Plug 'nvim-lualine/lualine.nvim'

" Avoir des icones en plus (DEPENDENCE SUPER IMPORTANT)
Plug 'kyazdani42/nvim-web-devicons'

" Pour parse du code (osef pour moi c'est de la dépendence)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Bibliothèques avec pleins de foncitonnalités déclarées dans le lua
Plug 'echasnovski/mini.nvim'

" Le thème
Plug 'EdenEast/nightfox.nvim'

" L'explorateur de fichier
Plug 'nvim-tree/nvim-tree.lua'

" Pour simplifier l'HTML
Plug 'mattn/webapi-vim'
Plug 'mattn/emmet-vim'

" Preview basique en markdown
Plug 'ixru/nvim-markdown'

" Config des LSP (j'utilise pas en vrai)
Plug 'williamboman/mason.nvim' 
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

call plug#end()

" Je remap le Leader à Espace car touche inutilisée
map <Space> <Leader>

" Remove whitespace
nmap <Space>r :%s/\s\+$//e<Enter>

" Pour tab/shifttab
vnoremap <Tab> >gV
vnoremap <S-Tab> <gV

" copy and paste
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" Pour bouger des lignes avec alt + lettre peu importe le mode
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Config d'Emmet
let g:user_emmet_leader_key='<Leader>'
let g:user_emmet_install_global = 0
autocmd FileType html,css,javascript EmmetInstall
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
\      'favicon':"<link rel=\"shortcut icon\" type=\"image/png\" href=\"logo.png\" />",
\    },
\  },
\}

" Syntaxe pour lier un type de fichier à une extension (ici prolog)
autocmd BufNewFile,BufRead *.pl set filetype=prolog
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" On affiche les lignes en relatif
set number relativenumber
set nu rnu

" Coloration syntaxique
syntax on

" Mappage de l'affichage de NvimTree à <Leader>e
nmap <Leader>e <cmd>NvimTreeToggle<cr>

" Truc pour que les tabs marchent et bien
set autoindent
set expandtab
set tabstop=4
set softtabstop=2
set shiftwidth=4

" Theme de NeoVim
colorscheme nordfox


" Fichier Lua de configuration
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
  ensure_installed = {},
  automatic_installation = true
})

EOF
