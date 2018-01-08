if 0 | endif
set encoding=utf-8
scriptencoding utf-8

if &compatible
  set nocompatible
endif

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_mac = has('mac')

augroup MyAugroup
  autocmd!
augroup END

if s:is_windows
  set shellslash
  let s:vimfiles_dir = expand('~/vimfiles')
else
  let s:vimfiles_dir = expand('~/.vim')
endif

let s:vimcache_dir   = expand('~/.cache/vim')

let s:viminfo        = s:vimcache_dir.'/viminfo'
let s:backup_dir     = s:vimcache_dir.'/backup'
let s:swap_dir       = s:vimcache_dir.'/swap'
let s:undo_dir       = s:vimcache_dir.'/undo'
let s:view_dir       = s:vimcache_dir.'/view'

let s:dein_dir       = s:vimcache_dir.'/dein.vim'
let s:dein_toml      = s:vimfiles_dir.'/rc/dein.toml'
let s:dein_cache_dir = expand('~/.cache/dein')

let s:local_vimrc    = s:vimfiles_dir.'/local.vimrc'

function! s:make_dir(dir) abort
  " silent! call mkdir(dir, 'p')
  if !isdirectory(a:dir)
    call mkdir(a:dir, 'p')
  endif
endfunction
call s:make_dir(s:vimcache_dir)
call s:make_dir(s:backup_dir)
call s:make_dir(s:swap_dir)
call s:make_dir(s:undo_dir)
call s:make_dir(s:view_dir)

if !isdirectory(s:dein_dir)
  echomsg 'dein.vim does not exists.'
  if executable('git')
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
  else
    echomsg 'git does not exists.'
  endif
endif

let g:mapleader = ','

if has('gui_running')
  set guioptions-=a guioptions-=i
  set guioptions-=r guioptions-=L
  set guioptions-=e guioptions-=m guioptions+=M guioptions-=t guioptions-=T guioptions-=g
  set guioptions+=c

  if s:is_windows
    set renderoptions=type:directx,renmode:5
    set guifont=Ricty_Diminished:h13.5:cSHIFTJIS,MS_Gothic:h13
  elseif s:is_mac
    set guifont=Ricty\ Regular:h17
    set macmeta
    set transparency=10
  endif
else
  let &t_ti .= "\e[1 q"
  let &t_SI .= "\e[5 q"
  let &t_EI .= "\e[1 q"
  let &t_te .= "\e[0 q"
endif

if isdirectory(s:dein_dir) && executable('git') && (executable('rsync') || executable('xcopy'))
  let g:dein#install_process_timeout = 600
  let g:dein#install_progress_type = 'tabline'
  if has('vim_starting')
    execute 'set runtimepath^='.s:dein_dir
  endif
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_cache_dir)
    call dein#add(s:dein_dir, {'rtp': ''})
    call dein#add('scrooloose/nerdtree')
    call dein#add('Shougo/unite.vim')
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')

    call dein#load_toml(s:dein_toml)

    call dein#end()
    call dein#save_state()
  endif

  call dein#call_hook('source')

  if dein#check_install()
    call dein#install()
  endif
  " if dein#check_update()
  "   call dein#update()
  " endif

  silent! execute 'helptags' s:dein_dir . '/doc/'
endif
filetype plugin indent on

" use Powerline Fonts
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme = 'papercolor'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" important

" moving around, searching and patterns
set whichwrap+=b,s,h,l,<,>,~,[,]
set incsearch
set ignorecase
set smartcase

" tags
set tags+=tags;

" displaying text
set scrolloff=5
if (v:version == 704 && has("patch785")) || v:version >= 705
   set breakindent
endif
set showbreak=>\ 
set display+=lastline
set redrawtime=500
set list
set listchars=tab:￫\ ,eol:⏎,extends:>,precedes:<
set number
set conceallevel=2
set concealcursor=nc

" syntax, highlighting and spelling
set hlsearch
nohlsearch

" multiple windows
set laststatus=2
set statusline=%F%m%r
set statusline+=%=
set statusline+=\ \|\ %{&fileformat},%{&fileencoding}%{(&bomb?\"(bom)\":\"\")}
set statusline+=\ \|\ %Y
set statusline+=\ \|\ %l/%L,%c
" set noequalalways
set splitright

" multiple tab pages
set showtabline=2
set tabline=%!MyTabLine()

function! MyTabLine()
  if !exists("s:tabline")
    let s:tabline = s:tab(16, 32, 8)
  endif
  return s:tabline.gen()
endfunction

function! s:tab(size, maxsize, minsize) abort
  let self = {}

  let self.size = a:size
  let self.maxsize = a:maxsize
  let self.minsize = a:minsize

  function! self.gen() abort dict
    let left = self.left()
    let right = self.right()
    let leftsize = strdisplaywidth(left)
    let rightsize = strdisplaywidth(right)

    let width = &columns
    let middlesize = width - leftsize - rightsize
    let middle = self.middle(middlesize)
    return left.middle.'%=%<'.right
  endfunction

  function! self.left() abort dict
    return ' '
  endfunction
  function! self.right() abort dict
    return ' '
  endfunction

  function! self.label(n) abort dict
    let buflist = tabpagebuflist(a:n)
    let curbuf = buflist[tabpagewinnr(a:n) - 1]
    let bufcount = len(buflist) > 1 ? len(buflist) : ''

    let tabmod = len(filter(copy(buflist), 'getbufvar(v:val, "&modified")')) ? '(+)' : ''
    let tabmod = getbufvar(curbuf, '&modified') ? '+' : tabmod

    let fname = fnamemodify(bufname(curbuf), ':t')
    let quickfix = getbufvar(curbuf, '&buftype') !~ 'quickfix' ? '' : '[Quickfix]'
    let nofile = getbufvar(curbuf, '&buftype') !~ 'nofile' ? '' : '[下書き]'

    let name = '[無題]'
    let name = len(quickfix) ? quickfix : name
    let name = len(nofile) ? nofile : name
    let name = len(fname) ? fname : name

    let label = ' '.a:n.tabmod.':'.bufcount.' '.name.' '
    return label
  endfunction

  function! self.middle(middlesize) abort dict
    let sep = '|'
    let labels = []
    for tabnr in range(1, tabpagenr('$'))
      let label = self.label(tabnr)
      let label = self.labelformat(label, sep, self.size, self.maxsize)
      call add(labels, label)
    endfor

    let maxsize = self.maxsize
    while a:middlesize < self.labelssize(labels, sep) && maxsize > self.size
      let maxsize = maxsize - 1
      let i = 0
      while i < len(labels)
        if maxsize < strdisplaywidth(labels[i].sep)
          let labels[i] = self.labelformat(labels[i], sep, self.size, maxsize)
        endif
        let i = i + 1
      endwhile
    endwhile

    if a:middlesize < self.labelssize(labels, sep)
      let persize = a:middlesize / tabpagenr('$')
      let persize = max([persize, self.minsize])
      let i = 0
      while i < len(labels)
        let labels[i] = self.labelformat(labels[i], sep, self.size, persize)
        let i = i + 1
      endwhile
    endif

    let i = 0
    let strlabels = ''
    while i < len(labels)
      let tabn = i + 1
      let hl = tabn is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
      let hl .= '%'.tabn.'T'
      let strlabels .= hl.labels[i].'%#TabLineFill#'.sep
      let i = i + 1
    endwhile

    return strlabels
  endfunction

  function! self.labelssize(labels, sep) abort dict
    let sum = 0
    for label in a:labels
      let sum = sum + strdisplaywidth(label.a:sep)
    endfor
    return sum
  endfunction

  function! self.substring(src, start, end) abort dict
    let splitlabel = split(a:src, '\zs')
    return join(splitlabel[a:start : a:end], '')
  endfunction

  function! self.labelformat(label, sep, size, maxsize) abort dict
    let label = a:label
    let label .= repeat(' ', a:size - strdisplaywidth(a:label.a:sep))

    let i = strchars(label)
    while strdisplaywidth(label.a:sep) > a:maxsize
      let label = self.substring(label, 0, i).'> '
      let i -= 1
    endwhile

    return label
  endfunction

  return self
endfunction

" terminal
" using the mouse
set mouse=a

" GUI
" printing
set printheader=%<%t%h%m%=%N

" messages and info
set novisualbell
set noerrorbells
set showcmd
set belloff=all
set helplang=ja,en

" selecting text
set clipboard+=unnamed

" editing text
set backspace=indent,eol,start
set pumheight=10
set matchtime=1
set matchpairs+=<:>
set nrformats=hex

" tabs and indenting
set tabstop=4 " tab width
set shiftwidth=2 " auto indent width
set softtabstop=2 " tabkey space
set expandtab " softtab
set autoindent
set smartindent

" folding
" diff mode
" mapping
" reading and writing files
set backup
execute 'set backupdir='.s:backup_dir

" the swap file
execute 'set directory='.s:swap_dir
set swapfile

" command line editing
set history=10000
set wildmode=full
set wildmenu
set undofile
execute 'set undodir='.s:undo_dir

" executing external commands
set keywordprg=:help

" running make and jumping to errors
" system specific
" language specific
set iminsert=0
set imsearch=0

" multi-byte characters
set fileencodings=utf8,cp932,eucjp
set ambiwidth=double

" various
set viewoptions-=options
execute 'set viewdir='.s:view_dir
execute 'set viminfo+=n'.s:viminfo

" php
let g:PHP_vintage_case_default_indent = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AutoCommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup MyAugroup
  " view
  autocmd BufWritePost ?* if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
  autocmd BufWinEnter ?* if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif

  " set autochdir
  autocmd BufEnter * execute 'silent! lcd '.expand('%:h')

  " auto jump
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | execute 'normal! g`"' | endif

  " quickfix
  autocmd QuickFixCmdPre vimgrep setlocal wildignore=*.gif,*.png,*.jpg,*.swf,*.flv,*.mp4,*.pdf,*.ttf,*.mp3,*.wav,tags
  autocmd QuickFixCmdPost vimgrep setlocal wildignore<
  autocmd QuickFixCmdPost *grep* cwindow

  " ftplugin
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType json setlocal conceallevel=0
  autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType qf call s:MyFTPluginQuickfix()

  " ftdetect
  autocmd BufNewFile,BufRead *.tpl set filetype=php

  " syntax
  autocmd VimEnter,ColorScheme * call s:MyHighlight()

augroup END

function! s:MyHighlight() abort
  if has('multi_byte_ime') || has('xim')
    " highlight Cursor guibg=DarkRed guifg=NONE
    highlight CursorIM guibg=Green guifg=NONE
  endif
endfunction

function! s:MyFTPluginQuickfix() abort
  setlocal statusline=%t%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%l/%L
  setlocal nowrap
  setlocal cursorline
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('$MYVIMRC')
  command! EditMyVimrc edit $MYVIMRC
endif
command! Wsource if &filetype == 'vim' | write | source % | else | echo 'this is not vimfile.' | endif
command! CdCurrent cd %:p:h
command! -bang Scratch execute '<bang>' == '!' ? 'tabedit' : 'new' | setlocal buftype=nofile noswapfile
command! DiffOrig vert new | set buftype=nofile | read ++edit # | 0delete_ | diffthis | wincmd p | diffthis
command! -nargs=1 VimGrepFile execute 'vimgrep /\v<args>/j %:p'
command! -nargs=1 VimGrepDir execute 'vimgrep /\v<args>/j **'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <ESC><ESC> :<C-u>nohlsearch<CR><ESC>
nnoremap <silent><C-e> :NERDTreeToggle<CR>

nnoremap Y y$

nnoremap <expr> gj &wrap ? 'j' : 'gj'
nnoremap <expr> gk &wrap ? 'k' : 'gk'
nnoremap <expr> j &wrap ? 'gj' : 'j'
nnoremap <expr> k &wrap ? 'gk' : 'k'

vnoremap <expr> gj &wrap ? 'j' : 'gj'
vnoremap <expr> gk &wrap ? 'k' : 'gk'
vnoremap <expr> j &wrap ? 'gj' : 'j'
vnoremap <expr> k &wrap ? 'gk' : 'k'

nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X

" nnoremap s <Nop>
" vnoremap s <Nop>
" nnoremap S <Nop>
" vnoremap S <Nop>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

nnoremap <C-n> :<C-u>tabnext<CR>
nnoremap <C-p> :<C-u>tabprevious<CR>

vnoremap . :normal .<CR>
vnoremap @ :<C-u>execute "'<,'>normal @".nr2char(getchar())<CR>

nnoremap <S-UP> <C-w>+
nnoremap <S-Down> <C-w>-
nnoremap <S-Left> <C-w><
nnoremap <S-Right> <C-w>>
nnoremap <C-UP> <C-w>K
nnoremap <C-Down> <C-w>J
nnoremap <C-Left> <C-w>H
nnoremap <C-Right> <C-w>L

noremap <Space> <Nop>
nnoremap <Space>j o<ESC>
nnoremap <Space>k O<ESC>
nnoremap <Space>w :<C-u>write<CR>
nnoremap <Space>q :<C-u>quit<CR>
nnoremap <Space>Q :<C-u>quit!<CR>
nnoremap <Space>bd :<C-u>bdelete<CR>
nnoremap <Space><Space> %
nnoremap <Space>* *N
nnoremap <Space>g* g*N
nnoremap <Space>n :<C-u>tabnext<CR>
nnoremap <Space>p :<C-u>tabprevious<CR>
nnoremap <Space>t :<C-u>tabedit<CR>

nnoremap - <Nop>
nnoremap -fh :<C-u>setfiletype html <Bar> set filetype?<CR>
nnoremap -fj :<C-u>setfiletype javascript <Bar> set filetype?<CR>
nnoremap -fp :<C-u>setfiletype php <Bar> set filetype?<CR>
nnoremap -fs :<C-u>setfiletype sql <Bar> set filetype?<CR>
nnoremap -fv :<C-u>setfiletype vim <Bar> set filetype?<CR>
nnoremap -fm :<C-u>setfiletype markdown <Bar> set filetype?<CR>
nnoremap -ft :<C-u>setfiletype text <Bar> set filetype?<CR>
nnoremap -eu :<C-u>setlocal fileencoding=utf8 fileencoding?<CR>
nnoremap -es :<C-u>setlocal fileencoding=sjis fileencoding?<CR>
nnoremap -w :<C-u>setlocal wrap! wrap?<CR>
nnoremap -c :<C-u>setlocal cursorline! cursorline?<CR>
nnoremap -n :<C-u>setlocal number! number?<CR>
nnoremap -t :<C-u>setlocal expandtab! expandtab?<CR>
nnoremap -i :<C-u>setlocal ignorecase! ignorecase?<CR>
nnoremap -h :<C-u>setlocal hlsearch hlsearch?<CR>

if exists('$MYVIMRC')
  nnoremap <F1> :<C-u>edit $MYVIMRC<CR>
  nnoremap <S-F1> :<C-u>tabedit $MYVIMRC<CR>
endif
execute 'nnoremap <F2> :<C-u>edit '.s:local_vimrc.'<CR>'
execute 'nnoremap <S-F2> :<C-u>tabedit '.s:local_vimrc.'<CR>'
execute 'nnoremap <F3> :<C-u>edit '.s:dein_toml.'<CR>'
execute 'nnoremap <S-F3> :<C-u>tabedit '.s:dein_toml.'<CR>'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
colorscheme molokai

if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif
