: # Combined batch and bash file to bootstrap dotfiles
: # Must be run as administrator on windows - for mklink
: << EOF
@echo off
goto batch_file
EOF

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sf $dir/.gitconfig ~/.gitconfig
ln -sf $dir/.gitignore ~/.gitignore

ln -sf $dir/.vim ~/.vim
ln -sf $dir/.vimrc ~/.vimrc
ln -sf $dir/.screenrc ~/.screenrc

ln -sf $dir/.bashrc ~/.bashrc
ln -sf $dir/.bash_aliases ~/.bash_aliases

ln -s $dir/bin ~/bin
ln -s $dir/.lftp ~/.lftp
exit

:batch_file
del %USERPROFILE%\.gitconfig
mklink %USERPROFILE%\.gitconfig %cd%\.gitconfig

del %USERPROFILE%\.gitignore
mklink %USERPROFILE%\.gitignore %cd%\.gitignore

del %USERPROFILE%\_vimrc
mklink %USERPROFILE%\_vimrc %cd%\.vimrc

rmdir %USERPROFILE%\.vim
mklink /d %USERPROFILE%\.vim %cd%\.vim

rmdir %USERPROFILE%\vimfiles
mklink /d %USERPROFILE%\vimfiles %cd%\.vim
