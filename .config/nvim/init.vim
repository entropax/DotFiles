"###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
"###            )    )`						 ###
"###     (     /\)  ((    (  `     `       (         )       (	 ###
"###    ))/   (  (__/     )(      (     `  )        /(      /(	 ###
"###   /((_) )\) /\ \__  (()\     )/    /(/(      )(_)     \()	 ###
"###  (_))   (_\_\ \ ,_\  ((_)_  ((_)  ((_)_\    ((_)    (_(\\	 ###
"###  /'__`\/' _ `\ \ \/ /\` __\/'__`\/\ '__`\  /'__`\  /\'\/'\	 ###
"### /\  __//\ \/\ \ \ \_\ \ \//\ \L\ \ \ \L\ \/\ \L\.\_\/>  </	 ###
"### \ \____\ \_\ \_\ \__\\ \_\\ \____/\ \ ,__/\ \__/.\_\/\_/\_\ ###
"###  \/____/\/_/\/_/\/__/ \/_/ \/___/  \ \ \/  \/__/\/_/\//\/_/ ###
"###                                     \ \_\			 ###
"###                                      \/_/			 ###
"###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###
"###Author:    Cain Maxwell <entropax@posteo.net>~~~~~~~~~~~~~~~~###
"###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###



"##########################"
"#####Preload section######"
"##########################"

"AutoStart Plug manager and install plugins
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'junegunn/goyo.vim'
Plug 'preservim/nerdtree'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
Plug 'bling/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
call plug#end()


"##########################"
"####Set main variables####"
"##########################"

set title
set bg=dark
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set colorcolumn=80
set laststatus=0
set noshowcmd
set tabstop=4
set shiftwidth=4
set expandtab
set nocompatible
set encoding=utf-8
set number relativenumber
set wildmode=longest,list,full "Enable autocompletion
set splitbelow splitright " Splits open at the bottom and right.
"set noruler
nnoremap c "_c
filetype plugin on
syntax on


"##########################"
"#####Set main remaps######"
"##########################"

" IMPORTANT!!! Set leaderKey for any custom map
    let mapleader =","

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>
" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>
" Replace ex mode with gq
	map Q gq
" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %<CR>
" Open my bibliography file in split
"	map <leader>b :vsp<space>$BIB<CR>
"	map <leader>r :vsp<space>$REFER<CR>


"##########################"
"###~~~~~~~~TIPS~~~~~~~~###"
"##########################"
" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Automatically deletes all trailing whitespace and newlines at end of file on save.
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre * %s/\n\+\%$//e
    autocmd BufWritePre *.[ch] %s/\%$/\r/e

" Function for toggling the bottom statusbar:
let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>

" Turns off highlighting on the bits of code that are changed, so the line
if &diff
    highlight! link DiffText MatchParen
endif


"##########################"
"###PLUGin configuration###"
"##########################"

" Goyo plugin (makes text more readable when writing prose):
	map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l


"##########################"
"###Autocommand section####"
"##########################"

" When this files are updated, renew configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts

" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %

" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler "<c-r>%"<CR>
" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>
" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex
	let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex
