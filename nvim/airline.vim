function! s:update_git_status()
  let g:airline_section_b = "%{get(g:,'coc_git_status','')}"
endfunction

let g:airline_section_b = "%{get(g:,'coc_git_status','')}"
let g:airline#extensions#coc#enabled = 1

autocmd User CocGitStatusChange call s:update_git_status()
