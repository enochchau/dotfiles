let g:javascript_plugin_jsdoc = 1
set re=0
let g:vim_jsx_pretty_colorful_config = 1
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" prolog syntax highlight
au BufRead,BufNewFile *.pro set filetype=prolog
