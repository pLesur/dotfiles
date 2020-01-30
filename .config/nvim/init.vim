""""""""""""""""""""
""" COMMON SENSE """
""""""""""""""""""""
" makes startup time MUCH FASTER
let g:python3_host_prog="/usr/bin/python3"

" disable auto executed vimscript (fucking RCE waiting to happen)
set nomodeline
" allow changing modified buffers
set hidden

set background=light
set number
set cursorline

" tabzzzz
set tabstop=4
set shiftwidth=4
set expandtab

" more room for the messages (lol c++ templates)
set cmdheight=2

" gotta go fast
set updatetime=0

" !!?!?? let's see
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" don't fold when opening file, but make the manual one syntax based
set foldlevel=99
set foldmethod=syntax

" change cwd to current netrw dir
let g:netrw_keepdir = 0

"""""""""""""""""""""
""" QOL SHORTCUTS """
"""""""""""""""""""""
" sanity-preserving shortcuts
inoremap jj <Esc>
command Q qa
" fuck ex mode
nnoremap Q <Nop>
nnoremap ]c ]czz
nnoremap ; :
set pastetoggle=<F9>

" search n replace
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>

" omni complete w/ tab
inoremap <expr> <tab> ((pumvisible())?("\<C-n>"):("<tab>"))
inoremap <expr> <s-tab> ((pumvisible())?("\<C-p>"):("<s-tab>"))

vnoremap <C-c> "+y
vnoremap <C-x> "+d
inoremap <C-S-v> "+p

" spellczeck
autocmd BufNewFile,BufRead *.tex set spell textwidth=80
autocmd BufNewFile,BufRead *.md set spell textwidth=80
autocmd BufNewFile,BufRead *.txt set spell textwidth=80

""""""""" TERM
" esc in terminal mode; unless it's fzf!
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
" enter insert mode when switching to terminal panel
autocmd BufWinEnter,WinEnter term://* startinsert
" ... and leave it when leaving the panel
autocmd BufLeave term://* stopinsert

" close nvr when closing git commands editor from terminal
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

tnoremap <C-w>w <C-\><C-n><C-w>w
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l

""""""""" TAB
tnoremap <M-1> <C-\><C-n>1gt
tnoremap <M-2> <C-\><C-n>2gt
tnoremap <M-3> <C-\><C-n>3gt
tnoremap <M-4> <C-\><C-n>4gt
tnoremap <M-5> <C-\><C-n>5gt
tnoremap <M-6> <C-\><C-n>6gt
tnoremap <M-7> <C-\><C-n>7gt
tnoremap <M-8> <C-\><C-n>8gt
tnoremap <M-9> <C-\><C-n>9gt
noremap <M-1> 1gt
noremap <M-2> 2gt
noremap <M-3> 3gt
noremap <M-4> 4gt
noremap <M-5> 5gt
noremap <M-6> 6gt
noremap <M-7> 7gt
noremap <M-8> 8gt
noremap <M-9> 9gt
noremap <M-0> :tabnew<CR>

""""""" BABY PLUGINS

" Search within a scope (a {...} program block).
" see http://vim.wikia.com/wiki/Search_in_current_function
nnoremap <Leader>[ /<C-R>=<SID>ScopeSearch('[[', 1)<CR><CR>
vnoremap <Leader>[ <Esc>/<C-R>=<SID>ScopeSearch('[[', 2)<CR><CR>gV
nnoremap <Leader>{ /<C-R>=<SID>ScopeSearch('[{', 1)<CR><CR>
vnoremap <Leader>{ <Esc>/<C-R>=<SID>ScopeSearch('[{', 2)<CR><CR>gV
nnoremap <Leader>/ /<C-R>=<SID>ScopeSearch('[[', 0)<CR>
vnoremap <Leader>/ <Esc>/<C-R>=<SID>ScopeSearch('[[', 2)<CR><CR>
function! s:ScopeSearch(navigator, mode)
    if a:mode == 0
        let pattern = ''
    elseif a:mode == 1
        let pattern = '\<' . expand('<cword>') . '\>'
    else
        let old_reg = getreg('@')
        let old_regtype = getregtype('@')
        normal! gvy
        let pattern = escape(@@, '/\.*$^~[')
        call setreg('@', old_reg, old_regtype)
    endif
    let saveview = winsaveview()
    execute 'normal! ' . a:navigator
    let first = line('.')
    normal %
    let last = line('.')
    normal %
    call winrestview(saveview)
    if first < last
        return printf('\%%>%dl\%%<%dl%s', first-1, last+1, pattern)
    endif
    return "\b"
endfunction

function! EasyTerminal()
    if !exists('g:easy_terminal_canari')
        let g:easy_terminal_canari = 1
        tabnew
        tabmove
        terminal
    endif
    tablast
endfunction
noremap <M-_> :call EasyTerminal()<CR>


" line breaks after the next comma
" (useful for breaking up long fn declarations)
call setreg('l', "f,ls")

" location list
let g:location_list_open = 0
function! LocationListToggle()
    if g:location_list_open == 0
        :silent! lopen
        let g:location_list_open = 1
    else
        :silent! lclose
        let g:location_list_open = 0
    endif
endfunction

" replace the default "man" by cppman (for cpp source files only)
autocmd FileType cpp set keywordprg=:term\ cppman

""""""""" PLUGINS
call plug#begin()

" random
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'lesurp/vim_spell_checker_rotation'

" cpp
Plug 'rhysd/vim-clang-format', {'for': 'cpp'}
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" lsp
Plug 'neoclide/coc.nvim', {'do': './install.sh nightly'}

call plug#end()

""""""""" END PLUGINS

""" AESTHETICS
colorscheme solarized
" NOTE: this stuff is for a light theme!
hi StatusLine term=reverse ctermfg=248 ctermbg=7
hi SignColumn term=reverse ctermfg=69 ctermbg=7
au InsertEnter * hi StatusLine term=reverse ctermfg=2 ctermbg=7
au InsertEnter * hi SignColumn term=reverse ctermfg=69 ctermbg=2
au InsertLeave * hi StatusLine term=reverse ctermfg=248 ctermbg=7
au InsertLeave * hi SignColumn term=reverse ctermfg=69 ctermbg=7


"""""""" PLUGIN CONF
nnoremap <leader>t :FZF<CR>
let g:fzf_buffers_jump = 1
let g:fzf_command_prefix = 'Fzf'
nnoremap <leader>b :FzfBuffers<CR>
function! s:fzf_statusline()
    highlight fzf1 ctermfg=161 ctermbg=248
    highlight fzf2 ctermfg=23 ctermbg=248
    highlight fzf3 ctermfg=237 ctermbg=248
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction
autocmd! User FzfStatusLine call <SID>fzf_statusline()

nnoremap <leader>sp :<C-U>call SpellCheckRotate(v:count)<cr>
let g:spell_checker_rotation = ['en_us', 'fr']

" we use the shortcut from coc, so we simply disable
let g:UltiSnipsExpandTrigger="<Nop>"
let g:UltiSnipsJumpForwardTrigger="<Nop>"
let g:UltiSnipsJumpBackwardTrigger="<Nop>"
let g:snips_author = "Paul Lesur"
let g:snips_github = "lesurp"

nnoremap <silent> <leader>c :cnext<CR>
nnoremap <silent> <leader>v :cprev<CR>

function! CocHandled()
    let coc_filetypes = ['c', 'cpp', 'cc', 'cxx', 'h', 'hpp', 'rust', 'javascript', 'python']
    return index(coc_filetypes, &filetype) == - 1
endfunction


" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>
nnoremap <silent> gc :CocList<CR>
nnoremap <silent> ge :CocList diagnostics<CR>
nnoremap <silent> gs :CocList outline<CR>
nnoremap <silent> gr :call CocAction('jumpReferences')<CR>
nmap <silent> gh :call CocAction('doHover')<CR>
nmap <silent> gx <Plug>(coc-fix-current)
" how do I get this?
"nnoremap <silent> gv :call CocAction('preview')<CR>
nnoremap <silent> <F2> :call CocAction('rename')<CR>

" hihglight other instance of the varialbe we chill on
autocmd CursorHold * silent call CocActionAsync('highlight')

let g:coc_snippet_next = '<C-s>'
inoremap <silent><expr> <c-s> pumvisible() ? coc#_select_confirm() : 
            \"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" if file sypported by CoC, run the global / selected formatting, otherwise
" run gg=G
nnoremap <expr> <leader>ff CocHandled() ? "gg=G''" : ":call CocAction('format')<CR>" 

