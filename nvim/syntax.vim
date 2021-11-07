let g:javascript_plugin_jsdoc = 1

" prolog syntax highlight
au BufRead,BufNewFile *.pro set filetype=prolog

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
