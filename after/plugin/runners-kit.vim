let $LANG='en'

set history=500

set wildmenu
set wildignore=*.o,*~,*.pyc,.git/*

set number
set relativenumber

set fillchars+=eob:\

set noruler

iab xdate <c-r>=strftime("%m/%d/%y %H:%M:%S")<cr>

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime

 " adds a x character wide column on the left showing fold indicators
set foldcolumn=1

" Adds syntax highlighting
syntax enable

" No sounds on error, no screen flash as alternative to no sound, sets visual bell terminal code to empty (ensure no screen flash)
set noerrorbells
set novisualbell
set t_vb=

" Vim doesn't force you to save / discard a buffer when working with multiple files
set hid

" Ignores case, overrides ignore case if case is present in search, highlights all search, and shows what you're searching before you press enter
set ignorecase
set smartcase
set hlsearch
set incsearch

" Pressing tab inserts actual tab instead of spaces, the tab displays as x columns wide, indentation commands shift by x columns, and pressing tab in insert moves the cursor x columns.
set noexpandtab
set tabstop=8
set shiftwidth=8
set softtabstop=8

" Sets tab spacing to other settings
nnoremap <leader>ti :setglobal noexpandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
nnoremap <leader>to :setglobal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nnoremap <leader>tp :setglobal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8<CR>

" Use utf8 for encoding, use unix file system instead of windows
set encoding=utf8
set ffs=unix

" No backup files, no temporary backup files, no swap files
set nobackup
set nowb
set noswapfile

" When wrapping, wrap at word boundaries instead of mid character, wrap long lines without needing horizontal scrolling
set lbr
set wrap

" Auto indent. new lines inherit indentation of previous line
set ai

" Remove highlighting
nnoremap <silent> <leader>rh :noh<cr>

" Restores cursor location when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Hides mode text on the bottom of teh screen, removes statusline entirely, and hides the tab bar even if multiple tabs are open
set noshowmode
set laststatus=0
set showtabline=0

" Removes trailing whitespace
fun! CleanExtraSpace()
	let save_cursor = getpos(".")
	let old_query = getreg("/")
	silent! %s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfun
" from every file except markdown
autocmd BufWritePre * if &filetype != 'markdown' | call CleanExtraSpace() | endif

" Persistent undo
if has('persistent_undo')
	let s:undo_dir = expand('~/.vim/temp_dirs/undodir')
	if !isdirectory(s:undo_dir)
		call mkdir(s:undo_dir, 'p', 0700)
	endif
	set undodir^=~/.vim/temp_dirs/undodir//
	set undofile
endif

autocmd FileType css set omnifunc=csscomplete#CompleteCSS

noremap <leader>j :Files<cr>
noremap <leader>k :Buffer<cr>
nnoremap <leader>/ :Rg<Space>
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let $FZF_DEFAULT_OPTS='--height 40% --reverse'

if executable('rg')
	let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git"'
	command! -nargs=* Rg call fzf#vim#grep(
		\ 'rg --column --line-number --no-heading --color=always --smart-case --hidden --glob "!.git" '.shellescape(<q-args>), 1,
		\ fzf#vim#with_preview(), 0)
endif

" ── NERDTree ────────────────────────────────────────────────
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 35
noremap <leader>of :NERDTreeFind<cr>
noremap <leader>ot :NERDTreeToggle<cr>
noremap <leader>oc :NERDTreeClose<cr>

" Exit Vim if NERDTree is the only window remaining
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" ── Startify ────────────────────────────────────────────────
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter *
	\ if !argc() && !exists('s:std_in') |
	\   Startify |
	\ endif

" ── Indent guides ───────────────────────────────────────────
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
nnoremap <leader>ig :IndentGuidesToggle<cr>

"
vnoremap <leader>? :Tabularize /
vnoremap <leader>sm :sort<cr>
vnoremap <leader>/ <Plug>Titlecase
nnoremap <leader>et :MundoToggle<cr>

let g:better_whitespace_enabled = 0
nnoremap <leader>wh :ToggleWhitespace<cr>
nnoremap <leader>go gf<cr>

" ── Line number toggles ────────────────────────────────────
nnoremap <leader>ln :set norelativenumber number<cr>
nnoremap <leader>lr :set nonumber relativenumber<cr>
nnoremap <leader>ll :call <SID>ToggleBothNumbers()<cr>

fun! s:ToggleBothNumbers()
	if &number && &relativenumber
		set nonumber norelativenumber
	else
		set number relativenumber
	endif
endf


" ── Commentary ──────────────────────────────────────────────
vnoremap . :Commentary<cr>

" ── vim-visual-multi ────────────────────────────────────────
let g:VM_leader = '\'
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-s>'
let g:VM_maps['Find Subword Under'] = '<C-s>'
let g:VM_maps["Select All"] = '<C-a>'
let g:VM_maps["Visual All"] = '<C-s>'
let g:VM_maps["Exit"] = '<Esc>'

" ── Goyo ────────────────────────────────────────────────────
nnoremap <silent> <leader>z :Goyo<cr>

" ── Format to width ─────────────────────────────────────────
function! s:FormatToWidth() abort
  let l:save_tw = &l:textwidth
  let l:save_fo = &l:formatoptions
  let l:save_ai = &l:autoindent
  let l:save_si = &l:smartindent
  let l:save_ci = &l:cindent
  let l:save_ie = &l:indentexpr
  let l:save_et = &l:expandtab

  try
    setlocal textwidth=120
    setlocal noautoindent nosmartindent nocindent indentexpr=
    setlocal formatoptions-=2
    setlocal expandtab

    let l:view = winsaveview()
    silent! keepjumps normal! gggqG
    call winrestview(l:view)

    silent! keeppatterns %s/\v(\S) {2,}(\S)/\1 \2/ge
    nohlsearch
  finally
    let &l:textwidth     = l:save_tw
    let &l:formatoptions = l:save_fo
    let &l:autoindent    = l:save_ai
    let &l:smartindent   = l:save_si
    let &l:cindent       = l:save_ci
    let &l:indentexpr    = l:save_ie
    let &l:expandtab     = l:save_et
  endtry
endfunction

nnoremap <leader>dtw :call <SID>FormatToWidth()<CR>

nnoremap <leader>e :e ~/buffer<cr>




