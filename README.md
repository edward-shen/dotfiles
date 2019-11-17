# Personal dotfiles

Yes. I've decided to make a public repository of my dotfiles. Yes, no one wants
nor needs to see it. I'm sorry. This is public so I can just clone from this
repository without setting up anything else.

## Theme
The theme is based off of the wallpaper, which is a vectored work of someone's rendition of the iconic Freedom Dive artwork.

## Notable includes
- zsh (sets both current user and root's default shell)
- i3-gaps-next
- polybar
- betterlockscreen
- Firacode, Font Awesome 4
- slack
- qbittorrent (which works better than the Windows binary...)
- rofi
- maim (instead of scrot)
- mpv
- The following languages:
  - Java
  - Intellij Java (With Intellij Ultimate edition)
  - Node (and Yarn)
- picom

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
