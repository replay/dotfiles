" vim: set filetype=vim :
if !has("autocmd")
  finish
endif
autocmd BufEnter .mutt-signatures setlocal textwidth=72
autocmd FileType pod setlocal textwidth=72
autocmd FileType make setlocal shiftwidth=8 tabstop=8
autocmd FileType tex setlocal textwidth=75 makeprg=make\ -s foldmethod=syntax formatoptions+=2
autocmd FileType c,cpp setlocal foldmethod=syntax
" Editing bash command lines.
autocmd BufRead,BufNewFile /tmp/bash-fc-* setlocal filetype=sh
autocmd BufNewFile,BufRead *.json setlocal filetype=javascript
autocmd FileType python setlocal foldminlines=5 foldnestmax=3 foldmethod=indent
function! JT_install_maps()
     noremap <buffer> <F2> gqap
    inoremap <buffer> <F2> <C-O>gwap
    vnoremap <buffer> <F2> gq
endfunction

autocmd BufRead,BufNewFile *.mkd,*.mdwn setlocal filetype=markdown
" I'm not sure about the comments setting . . .
" XXX Should I have formatoptions+=2?
" XXX formatoptions and formatlistpat don't do what I want; I want lines
" starting with * to be recognised as numbered lists; formatlistpat correctly
" matches them, but reformatting doesn't do the right thing.
autocmd FileType markdown setlocal formatoptions+=n formatlistpat=^\\s*\\(\\d\+\\|\\*\\)[\\]:.)}\\t\ ]\\s* comments=n:>
autocmd BufRead,BufNewFile *.twiki setlocal filetype=twiki
autocmd FileType twiki setlocal textwidth=1000
" tmux(1)
autocmd BufNewFile,BufRead .tmux.conf*,tmux.conf* setlocal filetype=tmux
autocmd FileType go setlocal noexpandtab shiftwidth=8 softtabstop=8 tabstop=8 foldmethod=syntax

" Turn on spelling, if the vim we're using supports it, for specific file types.
if has("spell")
    autocmd FileType html,tex,text,mail,perl,pod,c,gitcommit,markdown,debchangelog setlocal spell
    " This turns on spell checking properly.
    autocmd FileType html,text,mail,gitcommit,markdown syntax spell toplevel
    autocmd BufReadPre,BufNewFile *.txt,svn-commit.* setlocal spell
    autocmd FileType text setlocal formatoptions+=nq
    autocmd BufReadPre,BufNewFile w3mtmp* setlocal spell tw=72
    autocmd FileType help,p4-spec setlocal nospell
endif

" Highlight long lines in mails, unless they're quoted.
autocmd FileType mail syn match mailLongLine "\%73v.*$"
autocmd FileType mail highlight def link mailLongLine Error

" Extend the list of things to be highlighted for SCS
autocmd FileType perl syn keyword perlTodo contained IMPROVE IMPLEMENT
"autocmd FileType perl syn clear perlPackageFold

autocmd FileType lisp syn keyword lispTodo contained XXX

" Try to highlight XXX in Latex source
autocmd FileType tex syn match texError "XXX"

" Highlight trailing whitespace, but not when typing.
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight link ExtraWhitespace Error
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

if has("eval")
    " I finally figured out how to call a function on editing a file.
    autocmd BufNewFile,BufReadPre * call JT_install_maps()
    autocmd FileType mail call JT_install_maps()
    " Recognise numbered lists when editing text files.
    autocmd FileType mail setlocal formatoptions+=n
endif

" Stop folding packages
"autocmd FileType perl syntax clear perlPackageFold

" *.t: Perl test scripts.
if has("eval")
    autocmd BufNewFile *.t call CS_populate_perl()
endif