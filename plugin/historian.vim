if exists("g:loaded_historian")
  finish
endif
let g:loaded_historian = 1

if !(exists("g:historian_registers"))
  let g:historian_registers = ['+']
endif
if !(exists("g:historian_length"))
  let g:historian_length = 10
endif

autocmd TextYankPost * :call historian#add_registers()
command! -nargs=* Historian call historian#display_registers(<f-args>)
