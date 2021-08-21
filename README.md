# dotfiles

[chezmoi](https://github.com/twpayne/chezmoi) managed dotfiles.

* Checkout:
  `chezmoi init git@github.com:theangryangel/dotfiles.git`
* Update or install:
  `chezmoi apply --mode=symlink`
* Adding:
  `chezmoi add ~/path/to/file`
* Pushing
  `chezmoi cd && git add . && git commit -m "some message"`
