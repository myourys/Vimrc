##Hector's Vimrc

    利用vundle管理插件,插件安装在~/.vim/bundle目录,插件安装修改vundles.vim文件   
    编译生成文件放在目录bin中,如果使用git,注意修改.gitigore文件

### Installation

1. Backup your old vim configuration files:

        mv ~/.vim ~/.vim.orig
        mv ~/.vimrc ~/.vimrc.orig

2. Clone and install this repo:

        git clone git://github.com/humiaozuzu/dot-vimrc.git ~/.vim
        ln -s ~/.vim/vimrc ~/.vimrc

3. Setup `Vundle`:

        git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

4. Install bundles. Launch vim(ignore the errors and they will disappear after installing needed plugins)and run:

        :BundleInstall

Thst's it!

FAQ:
1.Plugin "AuthorInfo":

    利用vundles安装后无法使用,进入~/.vim/bundle/AuthorInfo目录将ftplugin改为plugin:
    mv ftplugin plugin
