: # Combined batch and bash file to bootstrap dotfiles
: # Must be run as administrator on windows - for mklink
: << EOF
@echo off
goto batch_file
EOF

ln -s .gitconfig ~/.gitconfig
ln -s .gitignore ~/.gitignore

ln -s .vim ~/.vim
ln -s .vimrc ~/.vimrc
ln -s .screen ~/.screen

ln -s bin ~/bin
exit

:batch_file
mklink %USERPROFILE%\.gitconfig %cd%\.gitconfig
mklink %USERPROFILE%\.gitignore %cd%\.gitignore

mklink %USERPROFILE%\_vimrc %cd%\.vimrc
mklink /d %USERPROFILE%\.vim %cd%\.vim
mklink /d %USERPROFILE%\vimfiles %cd%\.vim
