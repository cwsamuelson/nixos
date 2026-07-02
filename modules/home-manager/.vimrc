" Gutter Numbers
set number
set relativenumber

augroup numbertoggles
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
    autocmd BufLeav,FocusLost,InsertEnter,WinLeave    * if &nu | set nornu | endif
    autocmd CmdlineEnter * set norelativenumber | redraw
    autocmd CmdlineLeave * set rnu
augroup END

" The idea is to detect markdown files, and open a new pane with the html
" rendered version.  On InsertLeave, repeat the render to keep it up to date.
" Will probably use something like: `BufLeave,FocusLost,InsertLeave,WinEnter`
augroup markdownrender
    autocmd!
    autocmd FileType markdown echo expand('<amatch>') | echo expand('<afile>') | exe "%!markdown_py " + expand('<afile>')
augroup END

" Visual Margin
set scrolloff=8

" Tab Size
set shiftwidth=2
set smarttab

" Prevent tabs looking like spaces
set tabstop=8
set softtabstop=0

set expandtab

" Allow mouse scroll and click
set mouse=a

" Lowercase search
set ignorecase
set smartcase

" Use the viminfo file
" ! - global variables that start with upper case
"   AAA - yes
"   Aaa - no
"   _AAA - no
"   A_A_A - yes
" '200 - files to remember marks
" <200 - lines to save in register
" -1024 - max register size in KiB
" % - buffer list
" h - disable highlight from previous search on load
set viminfo=!,'200,<200,s1024,%,h

" File Completion
set wildignorecase
set wildmode=longest,list:lastused
"set wildoptions=fuzzy,pum
