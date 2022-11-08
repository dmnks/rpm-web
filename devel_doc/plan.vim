function! s:cycle()
    let l:chars = [' ', '-', '+']
    let l:line = getline('.')
    if l:line[0] == '*'
        return
    endif
    let l:i = index(l:chars, l:line[0])
    let l:c = l:chars[(l:i + 1) % len(l:chars)]
    call setline('.', l:c . l:line[1:])
endfunction

function! s:gitshow()
    let l:hash = split(getline('.')[2:], ' ')[0]
    silent exec "!git show --color " . l:hash . " | less -cR" | redraw!
endfunction

function! s:initplan()
    nmap <buffer> <silent> <space>  :call <sid>cycle()<cr>
    nmap <buffer> <silent> <cr>     :call <sid>gitshow()<cr>
endfunction

autocmd BufNewFile,BufRead ~/.cherry-plan/* call <sid>initplan()
