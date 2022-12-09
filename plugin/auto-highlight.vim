if exists('g:auto_highlight_loaded')
  finish
endif
let g:auto_highlight_loaded = 1

function! s:AutoHighlightWord()
  if get(w:, 'auto_highlight_enabled', 0) == 0
    return
  endif

  silent! call s:ClearMatches()

  let s:word = expand('<cword>')

  if match(s:word, '\w\+') >= 0 && len(s:word) > 1
    let s:escaped_word = escape(s:word, '\')
    call add(w:highlight_ids, matchadd('AutoHighlightWord', '\<'.s:escaped_word.'\>', 0))
  endif
endfunction

function! s:ClearMatches()
  if !exists('w:highlight_ids')
    let w:highlight_ids = []
  endif

  let ids = w:highlight_ids

  while !empty(ids)
    silent! call matchdelete(remove(ids, -1))
  endwhile
endfunction

function! s:ToggleAutoHighlightWord(enable)
  let w:auto_highlight_enabled = a:enable
  if a:enable
    if !exists('#AutoHighlightWord')
      augroup AutoHighlightWord
        autocmd!
        autocmd CursorHold    * call s:AutoHighlightWord()
        autocmd CursorMoved   * call s:ClearMatches()
        autocmd WinLeave      * call s:ClearMatches()
      augroup END
    endif
  else
    silent! call s:ClearMatches()
  endif
endfunction

highlight! link AutoHighlightWord CursorLineNr

if !exists('g:auto_highlight#disabled_on_start')
  call s:ToggleAutoHighlightWord(1)
endif

command! DisableAutoHighlightWord    call s:ToggleAutoHighlightWord(0)
command! EnableAutoHighlightWord     call s:ToggleAutoHighlightWord(1)
command! ToggleAutoHighlightWord     call s:ToggleAutoHighlightWord(!get(w:, 'auto_highlight_enabled', 0))

" vim:set sw=2 sts=2:
