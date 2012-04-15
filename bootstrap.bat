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
ln -sf $dir/.screen ~/.screen

ln -s bin ~/bin
exit

:batch_file
mklink %USERPROFILE%\.gitconfig %cd%\.gitconfig
mklink %USERPROFILE%\.gitignore %cd%\.gitignore

mklink %USERPROFILE%\_vimrc %cd%\.vimrc
mklink /d %USERPROFILE%\.vim %cd%\.vim
mklink /d %USERPROFILE%\vimfiles %cd%\.vim
