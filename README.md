# Personal dotfiles

Yes. I've decided to make a public repository of my dotfiles. Yes, no one wants
nor needs to see it. I'm sorry. This is public so I can just clone from this
repository without setting up anything else.

## Notable includes
- zsh (sets both current user and root's default shell)
- i3-gaps
- polybar
- betterlockscreen
- Firacode, Font Awesome 4
- slack
- qbittorrent (which works better than the Windows binary...)
- rofi
- thunar
- maim (instead of scrot)
- mpv
- The following languages:
  - Java
  - Intellij Java (With Intellij Ultimate edition)
  - Node (and Yarn)
- compton

## Notable behavior
The following configs will be prompted during the installation:
- SSH key generation
- Install problematic packages (known to fail for some reason or another):
  - code (need to increase ulimit)
  - discord (missing PGP key)
- Install proprietary packages:
  - spotify
- Install fun packages, e.g.:
  - cowsay
  - fortune

## Additional information
This was based on @kylesferrazza's dotfiles, which you can find [here][kyle].
Thank you!

[kyle]: https://github.com/kylesferrazza/dot
