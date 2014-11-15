
set nocompatible

" plugins for vim
execute pathogen#infect()

" Syntax, Colorscheme and Gui Options
set number " line numbers
set colorcolumn=80
set ruler " Always show current positions along the bottom
set showmatch " show matching brackets
" Keep 10 lines (top/bottom) for scope
set scrolloff=10
" Disable wrapping by default
set nowrap
set linebreak

set backspace=2 " make backspace work like most other apps

" spell checking
set spell
autocmd FileType scala set nospell

filetype plugin indent on

" colors
syntax on
set background=dark
if has("gui_running")
	set guifont=Ubuntu\ Mono\ 11
	" disable gvim toolbar
	set guioptions-=T
	colorscheme molokai
else
	let g:molokai_original = 1
	colorscheme molokai
endif

" Searching: highlight results, search while typing, ignore case when only lowercase
set hlsearch incsearch ignorecase smartcase

" Show invisibles
set list
set listchars=tab:›\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

augroup custom

" Remove trailing whitespace on save
autocmd custom BufWritePre * :%s/\s\+$//e

" Automatically read files when they were modified externally
set autoread

" Indent settings
set tabstop=4
set shiftwidth=4
set noexpandtab
"set smartindent (smartindent doesn't work with smartinput well)
set autoindent
"set cinkeys=0{,0},:,0#,!,!^F

" Detect Indentation plugin
autocmd custom BufReadPost * :DetectIndent

" Folding
set foldmethod=indent
set foldlevelstart=99
set foldnestmax=3
set nofoldenable

" autocomplete
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" Tab completion when entering filenames, ctrlp plugin
set wildignore+=*.o,*.obj,.git,*.rbc,.hg,.svn,*.pyc,.vagrant,.gitignore,.DS_Store,*.jpg,*.jpeg,*.png,*.gif,*.bmp,*/target/*,*/node_modules/*,*.class


" always switch to the current file directory
" set autochdir

" share clipboard with the system
set clipboard=unnamedplus

" directory to place swap files in
set directory=~/.vim/tmp

" Swap, Undo and Backup Folder Configuration
set directory=~/.vim/swap
set backupdir=~/.vim/backup
set undodir=~/.vim/undo
set backup
set undofile

" Save and restore vim session
if has("gui_running")
	set sessionoptions=curdir,resize,winpos
	autocmd VIMEnter * :source ~/.vim/.session
	autocmd VIMLeave * :mksession! ~/.vim/.session
endif

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Relative edit file
command -nargs=1 Re :e %:p:h/<args>
command -nargs=1 Rsp :sp %:p:h/<args>
command -nargs=1 Rvsp :vsp %:p:h/<args>

" :W is the same as :w
:command W w

" Syntastic
let g:syntastic_javascript_checkers = ['jshint', 'jscs']
let g:syntastic_javascript_jscs_args = "--esnext"

""" Powerline settings
let g:Powerline_stl_path_style = 'short'
" make sure powerline always is visible
set laststatus=2

" gundo
nnoremap <F5> :GundoToggle<CR>

" execute make
noremap <Leader>m :w<CR>:!make<CR>

" NERDTree settings
let NERDTreeIgnore = ['\.(o|obj)$']
noremap <F4> :NERDTreeToggle<CR>

" Per folder .vimrc files
set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

" Use mouse in terminal
set mouse=a

" 'bash' like tab completion for filenames
set wildmode=longest,list,full
set wildmenu

" http://stackoverflow.com/a/4294176/430730
" Create directory if it doesn't exist when creating a new file
function s:MkNonExDir(file, buf)
	if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
		let dir=fnamemodify(a:file, ':h')
		if !isdirectory(dir)
			call mkdir(dir, 'p')
		endif
	endif
endfunction
augroup BWCCreateDir
	autocmd!
	autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
