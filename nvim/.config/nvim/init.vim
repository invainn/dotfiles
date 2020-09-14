syntax on

set guicursor=
set noshowmatch
set relativenumber
set nohlsearch
set noerrorbells
set hidden
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set runtimepath+=~/.vim
set undofile
set incsearch
set scrolloff=8
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

set colorcolumn=120
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" TODO: Look up NeoVim pack
call plug#begin('~/.vim/plugged')

Plug 'cocopon/iceberg.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'

Plug 'tweekmonster/gofmt.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'

Plug 'christoomey/vim-tmux-navigator'

Plug 'ThePrimeagen/vim-be-good'
Plug 'vim-airline/vim-airline'

Plug 'vim-test/vim-test'
Plug 'tpope/vim-dispatch'

call plug#end()

set t_Co=256
if has('termguicolors')
  set termguicolors

  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
end

set background=dark    " Setting dark mode
colorscheme iceberg

let g:airline_theme='iceberg'

if executable('rg')
  let g:rg_derive_root='true'
endif

let mapleader=" "
let g:netrw_browse_split=0
let g:netrw_banner=0
let g:netrw_winsize=25

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'

" lsp stuff
lua << EOF
  local on_attach_all = function ()
    require'completion'.on_attach()
    require'diagnostic'.on_attach()
  end

  require'nvim_lsp'.pyls.setup{on_attach=on_attach_all}
  require'nvim_lsp'.vimls.setup{on_attach=on_attach_all}
  require'nvim_lsp'.tsserver.setup{on_attach=on_attach_all}
  require'nvim_lsp'.jsonls.setup{on_attach=on_attach_all}
  require'nvim_lsp'.cssls.setup{on_attach=on_attach_all}
  require'nvim_lsp'.bashls.setup{on_attach=on_attach_all}
EOF

let g:diagnostic_enable_virtual_text = 1
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.rename()<cr>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<cr>

" Test stuff
tmap <C-o> <C-\><C-n>
let test#strategy = "dispatch"
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>

" Diagnostic stuff
nnoremap <leader>dn :NextDiagnosticCycle<CR>
nnoremap <leader>dp :PrevDiagnosticCycle<CR>

" Go back
nnoremap <leader>b <C-o>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pf :Files<CR>
nnoremap <leader>pg :GFiles<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>ps :Rg<SPACE>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>

" vim-fugitive commands
nmap <leader>gl :diffget //3<CR>
nmap <leader>gh :diffget //2<CR>
nmap <leader>gs :G<CR>
