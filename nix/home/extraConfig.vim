"This must be first, because it changes other options as a side effect.
set nocompatible

colorscheme gruvbox

set number                     " Show current line number
set relativenumber             " Show relative line numbers
 
" map*leader {{{
let mapleader = "\<Space>"
let maplocalleader="\\"
" }}}


" Backup/swap/undo directories {{{
set backupdir=~/.config/nvim/backup
set directory=~/.config/nvim/swaps
set undodir=~/.config/nvim/undo
set undofile
" }}}

" Environment {{{ 
" map */+ registers to macOS pastebuffer
set clipboard=unnamed
" }}}

" Search {{{
set ignorecase
set smartcase
" }}}

" Whitespace {{{
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set list listchars=tab:»·,trail:·
" }}}

" Misc {{{
set scrolljump=5
set scrolloff=3
" }}}

" Mappings {{{
nnoremap <leader>sv :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>ev :edit ~/.config/nvim/init.vim<cr>

" kj = <esc> {{{
inoremap kj <esc>
cnoremap kj <esc>
vnoremap kj <esc>

" Jumping between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" }}}

" }}}


" }}}

" Plugin config {{{

" nvim-telescope telescope.nvim
" ----------
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" ----------

" }}}




" !!!! Lua below here !!!!
lua << END
require('lualine').setup {
  options = { theme  = custom_gruvbox },
}
END
