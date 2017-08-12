if !exists("g:syntax_on")
    syntax enable
endif

" fold setting
set foldmarker={{,}} foldlevel=0 
autocmd FileType vim setlocal foldmethod=marker

" VUNDLE{{
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
" Autotag "{{
Plugin 'craigemery/vim-autotag'
let g:autotagTagsFile=".tags"
"}}
" Incsearch {{
    Plugin 'haya14busa/incsearch.vim'
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)

    " :h g:incsearch#auto_nohlsearch
    set hlsearch
    let g:incsearch#auto_nohlsearch = 1
    map n  <Plug>(incsearch-nohl-n)
    map N  <Plug>(incsearch-nohl-N)
    map *  <Plug>(incsearch-nohl-*)
    map #  <Plug>(incsearch-nohl-#)
    map g* <Plug>(incsearch-nohl-g*)
    map g# <Plug>(incsearch-nohl-g#)

    Plugin 'haya14busa/incsearch-fuzzy.vim'
    map z/ <Plug>(incsearch-fuzzy-/)
    map z? <Plug>(incsearch-fuzzy-?)
    map zg/ <Plug>(incsearch-fuzzy-stay)

"}}
"Nerd commenter/tree {{
    Plugin 'scrooloose/nerdcommenter'
    " nerdcommenter
    map <Leader><Leader> <Leader>c<space>
    Plugin 'scrooloose/nerdtree'
    " NERDTree
    map <Tab> :NERDTreeToggle<CR>
"}}
"Emmet {{
    Plugin 'mattn/emmet-vim'
    " emmet
    let g:user_emmet_install_global = 0
    autocmd FileType html,css,php,js EmmetInstall
    autocmd FileType html,css,php,js imap <expr> <tab> emmet#expandabbrintelligent("\<tab>")
"}}
" Multi-Cursors{{
    Plugin 'terryma/vim-multiple-cursors'
    " vim-multiple-cursors 
    "let g:multi_cursor_next_key='<c-n>'
    let g:multi_cursor_prev_key='<c-b>'
    "let g:multi_cursor_skip_key='<c-x>'
    "let g:multi_cursor_quit_key='<esc>'
    nnoremap <silent> <m-j> :multiplecursorsfind <c-r>/<cr>
    vnoremap <silent> <m-j> :multiplecursorsfind <c-r>/<cr>
"}}
"Easy Motion {{
    Plugin 'easymotion/vim-easymotion'
    " easymotion
    map <leader> <plug>(easymotion-prefix)
    " <leader>f{char} to move to {char}
    map  <leader>f <plug>(easymotion-bd-f)
    nmap <leader>f <plug>(easymotion-overwin-f)
    " s{char}{char} to move to {char}{char}
    nmap s <plug>(easymotion-overwin-f2)
    " move to line
    map <leader>l <plug>(easymotion-bd-jk)
    nmap <leader>l <plug>(easymotion-overwin-line)
    " move to word
    map  <leader>w <plug>(easymotion-bd-w)
    nmap <leader>w <plug>(easymotion-overwin-w)
"}}
Plugin 'Valloric/YouCompleteMe', { 'do': './install.py' } " completion
call vundle#end()            " required
filetype plugin indent on    " required
"}}

 "GENERAL{{
set hlsearch
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set backspace=2
set autoindent
set smartindent
set clipboard+=unnamed " unnamed register "
set splitright
set splitbelow
set ignorecase " Case-insensitive searching.
set smartcase  " But case-sensitive if expression contains a capital letter.
set enc=utf8
set mouse=a " click to change cursor
set nobackup " no back up file
set noswapfile " you can open the same file in different places
set noeb vb t_vb= " disable sound
set nocp
set nomodeline
set noshowmode " do not display current mode

if &term =~ '^xterm'
  " 4 -> solid underscore
  let &t_SI .= "\<Esc>[3 q"
  " solid block
  let &t_SR .= "\<Esc>[2 q"
  let &t_EI .= "\<Esc>[2 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
endif
" Eliminate Strange tmux status window disappear bug
autocmd VimLeave * execute "echo ''"

"ctags
"autocmd BufEnter * silent! lcd %:p:h
set tags+=.tags,./.tags;

" Insert mode shortcut
inoremap <C-CR> <Esc>o
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-e> <Esc>$a
inoremap <C-f> <Esc>wa
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Copy full path
noremap <leader>p :let @+ = expand('%:p')<CR>

set timeoutlen=1000 ttimeoutlen=0
"}}

" THEME{{
set background=dark
colors solarized 
"colors material-theme 
"colors elflord

" Hide Line Number
nmap <Leader>n :set invnumber<CR>:set invrnu<CR> 

" line numbers
set number " show line numbers
set rnu " show relative line numbers
set numberwidth=4 " line numbers width
hi CursorLineNr term=bold ctermfg=white 
hi LineNr term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE 

set ruler
set rulerformat=%40(%=%1*%m%r%w\ %t%)
hi User1 term=NONE cterm=bold ctermfg=white ctermbg=NONE 

set statusline=
set statusline+=%2*
set statusline+=%3*%=%m%r%w\ %t
hi User2 term=NONE cterm=NONE ctermfg=black ctermbg=white 
hi User3 term=NONE cterm=bold ctermfg=black ctermbg=white

" how many characters in a line
"set textwidth=80 " make it obvious where 80 characters is
"set colorcolumn=+1 " color column after 'textwidth
"}}

" SELF DEFINED FUNCTION{{
" rsync{{
set exrc
set secure

function RemoteSync ()
    if !exists("g:enable_rsync") || g:enable_rsync == 0
        return
    endif

    let rsync_command = "rsync -avr " . g:rsync_local . " " . g:rsync_remote . " 1>/dev/null &"
    execute "!" . rsync_command
endfunction

au BufWritePost,FileWritePost * silent call RemoteSync()
"}}
"Compile{{
nmap <C-@> :call Compile()<CR>
function Compile()
	if expand('%:e') ==# "java"
		:!javac % && java %<
	elseif expand('%:e') ==# "c"
		:!gcc -g % -o %<.out && ./%<.out
	elseif expand('%:e') ==# "cpp"
		:!g++ -g % -o %<.out && ./%<.out
	elseif expand('%:e') ==# "py"
		:!python %
	elseif expand('%:e') ==# "sql"
		:!mysql TEST < %
	elseif expand('%:e') ==# "php"
		:!php %
	elseif expand('%:e') ==# "js"
		:!node %
	elseif expand('%:e') ==# "sh"
		:!bash %
	elseif expand('%:e') ==# "r" || expand('%:e') ==# "R"
		:!Rscript %
	elseif expand('%:e') ==# "tex"
		:!xelatex % && rm %<.out && rm %<.log && rm %<.aux && open %<.pdf
	endif
endfunction
"}}
"Modifier Key Mapping{{
if &term =~ "xterm" || &term =~ "screen" || &term =~ "builtin_gui"
  " Ctrl-Enter
  set  <F13>=[25~
  map  <F13> <C-CR>
  map! <F13> <C-CR>

  " Shift-Enter
  set  <F14>=[27~
  map  <F14> <S-CR>
  map! <F14> <S-CR>

  " Ctrl-Space
  set  <F15>=[29~
  map  <F15> <C-Space>
  map! <F15> <C-Space>

  " Shift-Space
  set  <F16>=[30~
  map  <F16> <S-Space>
  map! <F16> <S-Space>

  " Ctrl-Backspace
  set  <F17>=[1;5P
  map  <F17> <C-BS>
  map! <F17> <C-BS>

  " Alt-Tab
  set  <F18>=[1;5Q
  map  <F18> <M-Tab>
  map! <F18> <M-Tab>

  " Alt-Shift-Tab
  set  <F19>=[1;5R
  map  <F19> <M-S-Tab>
  map! <F19> <M-S-Tab>

  " Ctrl-Up
  set  <F20>=[1;5A
  map  <F20> <C-Up>
  map! <F20> <C-Up>

  " Ctrl-Down
  set  <F21>=[1;5B
  map  <F21> <C-Down>
  map! <F21> <C-Down>

  " Ctrl-Right
  set  <F22>=[1;5C
  map  <F22> <C-Right>
  map! <F22> <C-Right>

  " Ctrl-Left
  set  <F23>=[1;5D
  map  <F23> <C-Left>
  map! <F23> <C-Left>

  " Ctrl-Tab
  set  <F24>=[31~
  map  <F24> <C-Tab>
  map! <F24> <C-Tab>

  " Ctrl-Shift-Tab
  set  <F25>=[32~
  map  <F25> <C-S-Tab>
  map! <F25> <C-S-Tab>

  " Ctrl-Comma
  set  <F26>=[33~
  map  <F26> <C-,>
  map! <F26> <C-,>

  " Ctrl-Shift-Space
  set  <F27>=[34~
  map  <F27> <C-S-Space>
  map! <F27> <C-S-Space>
endif
"}}
"}}
