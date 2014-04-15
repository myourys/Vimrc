"导入vundle设置
source ~/.vim/bundles.vim

"定义变量
if(has("win32") || has("win95") || has("win64") || has("win16"))
    let g:iswindows=1
else
    let g:iswindows=0
endif

if has("unix")
	let s:uname = system("uname")
    if s:uname == "Darwin\n"
        let g:ismacox=1
    endif
endif

if g:iswindows==1
    " 导入Window 既有的默认配置
    source $VIM/mvimrc/vim/mswin.vim

    " Win鼠标风格
    behave mswin
endif

" 不要使用vi的键盘模式，而是vim自己的
set nocompatible
" 去掉输入错误的提示声音
set noeb




"----------------------  编码  --------------------
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,cp936

 source $VIMRUNTIME/delmenu.vim
 source $VIMRUNTIME/menu.vim

 "vim提示信息乱码的解决
language messages zh_CN.utf-8

"----------------------   格式 -------------------
"------ 语法高亮 ------
syntax enable                    " 打开语法高亮
syntax on                        " 开启文件类型侦测
filetype indent on               " 针对不同的文件类型采用不同的缩进格式
filetype plugin on               " 针对不同的文件类型加载对应的插件
filetype plugin indent on        " 启用自动补全
colorscheme darkblue             " 配色方案

" NeoComplCache 自动补全
let g:neocomplcache_enable_at_startup=1
let g:neoComplcache_disableautocomplete=1
    "let g:neocomplcache_enable_underbar_completion = 1
    "let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_smart_case=1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
set completeopt-=preview


" 自动缩进
set autoindent
set cindent

" Tab键的宽度
set tabstop=4

" 统一缩进为4
set softtabstop=4
set shiftwidth=4

" 用空格代替制表符
set expandtab

"搜索逐字符高亮
set hlsearch
set incsearch

" 用空格键来开关折叠
set foldenable
set foldmethod=syntax         "用语法高亮来定义折叠
set foldlevel=100            " 禁止自动折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0

" 启动的时候不显示那个援助索马里儿童的提示
set shortmess=atI

" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\

" 高亮显示匹配的括号
set showmatch

" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=5

" 增强模式中的命令行自动完成操作
set wildmenu

" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2

" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l

"---------------------------- GUI配置 -----------------------
if has("gui_running")
    set guioptions-=m " 隐藏菜单栏
    set guioptions-=T " 隐藏工具栏
    set guioptions-=L " 隐藏左侧滚动条
   " set guioptions-=r " 隐藏右侧滚动条
   " set guioptions-=b " 隐藏底部滚动条
   " set showtabline=0 " 隐藏Tab栏
endif





"单个文件编译
map <F5> :call Do_OneFileMake()<CR>
function Do_OneFileMake()
    w!

    if expand("%:p:h")!=getcwd()
        echohl WarningMsg | echo "Fail to make! This file is not in the current dir! Press <F7> to redirect to the dir of this file." | echohl None
        return
    endif

    let sourcefileename=expand("%:t")
    if (sourcefileename=="" || (&filetype!="cpp" && &filetype!="c" && &filetype!="lua"))
        echohl WarningMsg | echo "Fail to make! Please select the right file!" | echohl None
        return
    endif

    let deletedspacefilename=substitute(sourcefileename,' ','','g')
    if strlen(deletedspacefilename)!=strlen(sourcefileename)
        echohl WarningMsg | echo "Fail to make! Please delete the spaces in the filename!" | echohl None
        return
    endif

    if &filetype=="c"
        if g:iswindows==1
            set makeprg=gcc\ -o\ bin/%<.exe\ %
        else
            set makeprg=gcc\ -o\ bin/%<\ %
        endif
    elseif &filetype=="cpp"
        if g:iswindows==1
            set makeprg=g++\ -o\ bin/%<.exe\ %
        elseif g:ismacox==1
            set makeprg=clang++\ -std=c++11\ -stdlib=libc++\ -o\ bin/%<\ %
        else
            set makeprg=g++\ -o\ bin/%<\ %
        endif
        "elseif &filetype=="cs"
        "set makeprg=csc\ \/nologo\ \/out:%<.exe\ %
    elseif &filetype=="lua"
        execute "!lua ".sourcefileename
        return
    endif

    if(g:iswindows==1)
        let outfilename="bin/".substitute(sourcefileename,'\(\.[^.]*\)' ,'.exe','g')
        let toexename=outfilename
    else
        let outfilename="bin/".substitute(sourcefileename,'\(\.[^.]*\)' ,'','g')
        let toexename=outfilename
    endif

    if filereadable(outfilename)
        if(g:iswindows==1)
            let outdeletedsuccess=delete(getcwd()."\\".outfilename)
        else
            let outdeletedsuccess=delete("./".outfilename)
        endif
        if(outdeletedsuccess!=0)
            set makeprg=make
            echohl WarningMsg | echo "Fail to make! I cannot delete the ".outfilename | echohl None
            return
        endif
    endif

    execute "silent make"
    set makeprg=make
    execute "normal :"
    if filereadable(outfilename)
        if(g:iswindows==1)
            execute "!".toexename
        else
            execute "!./".toexename
        endif
    endif
    execute "copen"
endfunction

"进行make的设置
map <F6> :call Do_make()<CR>
map <c-F6> :silent make clean<CR>
function Do_make()
    set makeprg=make
    execute "silent make"
    execute "copen"
endfunction




"-------------- 快捷键 ------------------

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" w!! to sudo & write a file
cmap w!! w !sudo tee >/dev/null %


" eggcache vim
nnoremap ; :
:command W w
:command WQ wq
:command Wq wq
:command Q q
:command Qa qa
:command QA qa

" 多标签切换
nmap <F3> <Esc>:tabprevious<CR>
map! <F3> <Esc>:tabprevious<CR>
nmap <F4> <Esc>:tabNext<CR>
map! <F4> <Esc>:tabNext<CR>
"运行Python
"map <F5> <Esc>:!python manage.py runserver

nmap <F10>  <Esc>:NERDTreeToggle<CR>
nmap <F9>  <Esc>:TagbarToggle<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" taglist
if g:ismacox==1
    let Tlist_Ctags_Cmd='/opt/local/bin/ctags'
endif
let Tlist_Auto_Highlight_Tag = 1
let Tlist_Auto_Open = 0         "自动打开
let Tlist_Auto_Update = 1
let Tlist_Close_On_Select = 0
let Tlist_Compact_Format = 0
let Tlist_Display_Prototype = 0
let Tlist_Display_Tag_Scope = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Exit_OnlyWindow = 0
let Tlist_File_Fold_Auto_Close = 0
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Hightlight_Tag_On_BufEnter = 1
let Tlist_Inc_Winwidth = 0
let Tlist_Max_Submenu_Items = 1
let Tlist_Max_Tag_Length = 30
let Tlist_Process_File_Always = 0
let Tlist_Show_Menu = 0
let Tlist_Show_One_File = 0
let Tlist_Sort_Type = "order"
let Tlist_Use_Horiz_Window = 0
let Tlist_Use_Right_Window = 1
let Tlist_WinWidth = 30
let tlist_php_settings = 'php;c:class;i:interfaces;d:constant;f:function' 

"NERDTree
let NERDTreeChDirMode=2 "当前目录和NERDTree目录保持一致
let NERDTreeQuitOnOpen=1 "打开文件时关闭树
let NERDTreeShowBookmarks=1 "显示书签
let NERDTreeMinimalUI=1 "不显示帮助面板
let NERDTreeDirArrows=0 "目录箭头 1 显示箭头 0传统+-|号
let NERDTreeIgnore=['.*\.o$']
let NERDTreeIgnore+=['.*\~$']
let NERDTreeIgnore+=['.*\.out$']
let NERDTreeIgnore+=['.*\.so$', '.*\.a$']
let NERDTreeIgnore+=['.*\.pyc$']


let g:acp_behaviorSnipmateLength=1 "snipMate 触发器补全

let NERDShutUp=1 "对NERD_commenter的设置
let mapleader="," "将<leader>定义为”,”键 其中<leader>是键盘映射，默认情况下是反斜杆
map <c-h> ,c<space> "支持单行和多行的选择，//格式


set nowrap "不换行
set ruler "右下角显示行列
set nu!       " 显示行号
highlight LineNr  guifg=white      " 行号前景色
highlight LineNr  guibg=brown    " 行号背景色

"搜索时忽略大小写 
set ignorecase


"添加作者信息插件
let g:vimrc_author='Hector'
let g:vimrc_email='myourys@gmail.com'
let g:vimrc_homepage='http://www.yiwuye.com'

"syntastic cpp支持c++11
"let g:syntastic_cpp_compiler = 'clang++'
if g:ismacox==1
    let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
endif

