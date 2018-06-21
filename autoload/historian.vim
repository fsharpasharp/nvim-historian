let g:historian_dictionary = {}
for register in g:historian_registers
  let g:historian_dictionary[register] = []
endfor

function! s:add_entry(list, entry) abort
  if len(a:list) == 0
    call add(a:list, a:entry)
    return
  endif
  if (a:list[-1] == a:entry)
    return
  endif
  call add(a:list, a:entry)
  if len(a:list) > g:historian_length
    call remove(a:list, 0)
  endif
endfunction

function! historian#add_registers() abort
  for register in g:historian_registers
    let s:entry = getreg(register)
    if s:entry == ''
      continue
    endif
    call s:add_entry(g:historian_dictionary[register], s:entry)
  endfor
endfunction

function! s:list_string(list) abort
  let msg = ''
  let i = 1
  for v in a:list
    let msg .= i . ' ' . strtrans(v) . "\n"
    let i += 1
  endfor
  return msg
endfunction

function! s:check_exists(dic, key)
    if !(has_key(a:dic, a:key))
      echom "No such register."
      return 0
    endif
    return 1
endfunction

function! s:paste(list, index)
  if (a:index <= len(a:list) && a:index >= 1)
    execute 'normal a' . a:list[a:index-1]
    return 1
  endif
  return 0
endfunction

function! historian#display_registers(...) abort
  if (a:0 == 1)
    if !(s:check_exists(g:historian_dictionary, a:1))
      return 0
    endif
    let list = g:historian_dictionary[a:1]
    echo s:list_string(list)
    let n = inputdialog("Which entry to paste? ")
    call s:paste(list, n)
    return
  endif
  if (a:0 != 2)
    let msg = ''
    for vs in items(g:historian_dictionary)
      let msg .= vs[0] . "\n"
      let msg .= s:list_string(vs[1])
    endfor
    echo msg
    return
  endif
  if !(s:check_exists(g:historian_dictionary, a:1))
    return 0
  endif
  if !(s:paste(g:historian_dictionary[a:1], a:2))
    echom "Index out of bounds"
  endif
endfunction
