# mac环境配置

1.安装Xcode

> xcode-select —install

2.安装home-brew

> /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)”

安装时会报curl: (7) Failed to connect to [raw.githubusercontent.com](http://raw.githubusercontent.com/) port 443: Connection refused

参考网络上的解决办法（[http://www.bubuko.com/infodetail-3454937.html](http://www.bubuko.com/infodetail-3454937.html)）因为我能够使用外网，所有使用命令export https\_proxy=http://127.0.0.1:1087.刚好我的AAEX对应的代理端口是1087

3.brew install vim,安装mccvim

4.修改\~/.bash\_profile,添加

> alias vi=vim
> alias vim=mvim
> allies mvim=‘/usr/local/bin/mvim -v’

然后刷新配置文件source \~/.bash\_profile,这样就是将原有的vim替换成mccvim

5.配置～/.vimrc

> vim \~/.vimrc

```
"--------------以下是vim的常规配置--------------------
set fenc=utf-8
set fencs=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936
set nocompatible
" 设置外观 -------------------------------------
set number                      "显示行号 
set showtabline=0               "隐藏顶部标签栏"
set guioptions-=r               "隐藏右侧滚动条" 
set guioptions-=L               "隐藏左侧滚动条"
set guioptions-=b               "隐藏底部滚动条"
set cursorline                  "突出显示当前行"
"set cursorcolumn                "突出显示当前列"
set langmenu=zh_CN.UTF-8        "显示中文菜单
" 变成辅助 -------------------------------------
syntax on                           "开启语法高亮
set nowrap                      "设置代码不折行"
set fileformat=unix             "设置以unix的格式保存文件"
set cindent                     "设置C样式的缩进格式"
set tabstop=4                   "一个 tab 显示出来是多少个空格，默认 8
set shiftwidth=4                "每一级缩进是多少个空格
set backspace+=indent,eol,start "set backspace&可以对其重置
set showmatch                   "显示匹配的括号"
set scrolloff=5                 "距离顶部和底部5行"
set laststatus=2                "命令行为两行"
autocmd FileType c,cpp,python set shiftwidth=4 | set expandtab
" 其他杂项 -------------------------------------
set mouse=a                     "启用鼠标"
if has('mouse')
	set mouse-=a			"这样能够解决鼠标选中代码，然后右键无法复制的问题
endif
set selection=exclusive
set selectmode=mouse,key
set matchtime=5					"显示匹配括号的时间 (以十分之一秒计)
set ignorecase                  "搜索模式时忽略大小写"
set incsearch					"输入搜索模式时同时高亮部分的匹配
set hlsearch                    "高亮搜索项"
set clipboard=unnamed			"共享剪切板
set noexpandtab                 "不允许扩展table"
set whichwrap+=<,>,h,l
set autoread					"有vim之外的改动自动重读文件

if version >= 603
	set helplang=cn
	set encoding=utf-8
endif
set splitbelow                  "允许在下部分分割布局
set splitright                  "允许在右侧部分分割布局
" 组合快捷键
nnoremap <C-J> <C-W><C-J>		"组合快捷键：- Ctrl-j 切换到下方的分割窗口
nnoremap <C-K> <C-W><C-K>		"组合快捷键：- Ctrl-k 切换到上方的分割窗口
nnoremap <C-L> <C-W><C-L>		"组合快捷键：- Ctrl-l 切换到右方的分割窗口
nnoremap <C-H> <C-W><C-H>		"组合快捷键：- Ctrl-h 切换到左方的分割窗口
"--------------以上是vim的常规配置--------------------
```

具体什么意思自己百度去。

6.安装vim插件管理器vundle

> git clone [https://github.com/gmarik/Vundle.vim.git](https://github.com/gmarik/Vundle.vim.git) \~/.vim/bundle/Vundle.vim

配置Vundle

```
"-------以下是Vundle的配置----------
set nocompatible              " be iMproved, required
filetype on                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'preservim/nerdtree'				"树型结构
Plugin 'Xuyuanp/nerdtree-git-plugin'	"nerdtree对git的支持
Plugin 'jiangmiao/auto-pairs'		"括号引号自动补全
Plugin 'preservim/nerdcommenter'	" 多行注释插件
Plugin 'ycm-core/YouCompleteMe'
Plugin 'taglist.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'tell-k/vim-autopep8'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"-------以上是Vundle的配置----------
```

打开vim之后运行:PluginInstall  , Vundle就会根据配置安装插件

7.安装nerdtree

> Plugin 'preservim/nerdtree’

8.添加nerdtree对git的支持

> Plugin 'Xuyuanp/nerdtree-git-plugin’

```
"-------以下是nerdtree和nerdtree-git-plugin的配置----------
"使用F3键快速调出和隐藏它
map <F3> :NERDTreeToggle<CR>

let NERDTreeChDirMode=1

"显示书签"
let NERDTreeShowBookmarks=1

"设置忽略文件类型"
let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']

"窗口大小"
let NERDTreeWinSize=25

" 修改默认箭头
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"How can I open a NERDTree automatically when vim starts up if no files were specified?
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" 打开vim时自动打开NERDTree
autocmd vimenter * NERDTree           

"How can I open NERDTree automatically when vim starts up on opening a directory?
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" 关闭vim时，如果打开的文件除了NERDTree没有其他文件时，它自动关闭，减少多次按:q!
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" 开发的过程中，我们希望git信息直接在NERDTree中显示出来， 和Eclipse一样，修改的文件和增加的文件都给出相应的标注， 这时需要安装的插件就是 nerdtree-git-plugin,配置信息如下
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

" 显示行号
let NERDTreeShowLineNumbers=1
let NERDTreeAutoCenter=1

" 在终端启动vim时，共享NERDTree
let g:nerdtree_tabs_open_on_console_startup=1
"-------以上是nerdtree和nerdtree-git-plugin的配置----------
```

9.括号自动补全（auto-pairs)

> Plugin 'jiangmiao/auto-pairs’

无需配置

10.多行注释

> Plugin 'preservim/nerdcommenter’
```
"------------以下是nerdcommenter的配置-----------------------
" nerdcommenter默认热键<leader>为'\'，这里将热键设置为','
let mapleader=','

" 设置注释快捷键
map <F4> <leader>ci<CR>
"------------以上是nerdcommenter的配置-----------------------
```

11.安装YouCompleteMe

> Plugin 'ycm-core/YouCompleteMe’

这个安装有点复杂在mac当中需要cmake 需要macvim 需要python

```
"------------以下是YouCompleteMe的配置--------------
" 补全菜单的开启与关闭
set completeopt=longest,menu                    " 让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
let g:ycm_min_num_of_chars_for_completion=2             " 从第2个键入字符就开始罗列匹配项
let g:ycm_cache_omnifunc=0                      " 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_autoclose_preview_window_after_completion=1       " 智能关闭自动补全窗口
autocmd InsertLeave * if pumvisible() == 0|pclose|endif         " 离开插入模式后自动关闭预览窗口

" 补全菜单中各项之间进行切换和选取：默认使用tab  s-tab进行上下切换，使用空格选取。可进行自定义设置：
"let g:ycm_key_list_select_completion=['<c-n>']
"let g:ycm_key_list_select_completion = ['<Down>']      " 通过上下键在补全菜单中进行切换
"let g:ycm_key_list_previous_completion=['<c-p>']
"let g:ycm_key_list_previous_completion = ['<Up>']
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"    " 回车即选中补全菜单中的当前项

" 开启各种补全引擎
let g:ycm_collect_identifiers_from_tags_files=1         " 开启 YCM 基于标签引擎
let g:ycm_auto_trigger = 1                  " 开启 YCM 基于标识符补全，默认为1
let g:ycm_seed_identifiers_with_syntax=1                " 开启 YCM 基于语法关键字补全
let g:ycm_complete_in_comments = 1              " 在注释输入中也能补全
let g:ycm_complete_in_strings = 1               " 在字符串输入中也能补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0 " 注释和字符串中的文字也会被收入补全

" 重映射快捷键
"上下左右键的行为 会显示其他信息,inoremap由i 插入模式和noremap不重映射组成，只映射一层，不会映射到映射的映射
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>           " force recomile with syntastic
"nnoremap <leader>lo :lopen<CR>    "open locationlist
"nnoremap <leader>lc :lclose<CR>    "close locationlist
"inoremap <leader><leader> <C-x><C-o>

nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR> " 跳转到定义处
let g:ycm_confirm_extra_conf=0                  " 关闭加载.ycm_extra_conf.py确认提示
"------------以上是YouCompleteMe的配置--------------
```

12.安装cats

> brew install ctags-exuberant

#创建软链接

> ln -s /usr/local/Cellar/ctags/5.8\_1/bin/ctags  /usr/local/bin/ctags

#使用which ctags查看是哪个ctags

#安装taglist.vim

Plugin 'taglist.vim'
```
"------------以下是taglist的配置-------------
let Tlist_Use_Right_Window = 1          "让taglist窗口出现在Vim的右边
let Tlist_File_Fold_Auto_Close = 1      "当同时显示多个文件中的tag时，设置为1，可使taglist只显示当前文件tag，其它文件的tag都被折叠起来。
let Tlist_Show_One_File = 1             "只显示一个文件中的tag，默认为显示多个
let Tlist_Sort_Type ='name'             "Tag的排序规则，以名字排序。默认是以在文件中出现的顺序排序
let Tlist_GainFocus_On_ToggleOpen = 1       "Taglist窗口打开时，立刻切换为有焦点状态
let Tlist_Exit_OnlyWindow = 1           "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_WinWidth = 32             "设置窗体宽度为32，可以根据自己喜好设置
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'  "这里比较重要了，设置ctags的位置，不是指向MacOS自带的那个，而是我们用homebrew安装的那个
map t :TlistToggle<CR>              "热键设置，我设置成Leader+t来呼出和关闭Taglist
"------------以上是taglist的配置-------------
```

着重注意配置当中的Tlist\_Ctags\_Cmd=‘/usr/local/bin/ctags’如果在ubuntu中路径会有些不同

13.安装python代码自动缩进（indentpython.vim）


Plugin 'vim-scripts/indentpython.vim’
```
"----------------以下是配置python和全栈的缩进风格--------
"配置python保持PEP8风格缩进
" 按照PEP8标准来配置vim
au BufNewFile,BufRead *.py set tabstop=4 |set softtabstop=4|set shiftwidth=4|set textwidth=79|set expandtab|set autoindent|set fileformat=unix
" 全栈开发根据文件类型设置au命令
au BufNewFile,BufRead *.js, *.html, *.css set tabstop=2|set softtabstop=2|set shiftwidth=2
"----------------以下是配置python和全栈的缩进风格--------
```

14.安装tell-k/vim-autopep8（将python代码自动格式化为符合pep8标准的代码）

必须先安装第三方包autopep8 执行easy-install autopep8
Plugin 'tell-k/vim-autopep8’

```
" ------------------以下是配置vim-autopep8----------
" Disable show diff window
let g:autopep8_disable_show_diff=1

" vim-autopep8自1.11版本之后取消了F8快捷键，需要用户自己为:Autopep8设置快捷键：
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
" ------------------以上是配置vim-autopep8----------
```至此mac上的环境算是安装完成了。

