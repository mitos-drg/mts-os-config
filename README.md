# Mitos Operating System Configuration

This repository contains detailed description of my personal operating system configuration (made with Arch Linux in mind) and varius scripts, utilities and even some configuration files both for it and for setting it up.

## Contents

1. [File structure](docs/files.md)
2. [Backup](#backup-startegies)
3. [Shell configuration](#shell-profile-and-environment-variables)


# Backup strategies

The backup stategy is simple: main PC will be acting as a autoritative source for most changes. For directories that may be edited on diffrent machines usage of git is highly encouraged. But in case that git isn't preffered they should be ones with only incremental changes. In those occassion (hopefully rare) that some files or directories have to be moved/renamed/deleted it'll just have to be done manually everywhere.

Projects will use git as much as possible, then newer projects put in archive will be git repositories too. As such and with only minimal possibility of non-git archival projects changing there shouldn't be too much problems with this strategy.

Then all buckup should be possible to be done with only single command in terminal.

The configurations files (at least temporarily) will go into `$BACKUP/config` directory, despite being scattered across the whole file system. That's why it's content wouldn't make sense to be synchronised with the `$HOME/.config` directory. They (for now) will have to be managed manually, but in near fuutre, hopefully, it could be incorporated into it's own git repository (maybe even a stripped down branch of this one) to offer fully fledged backup capabilities.

# Configurations

For the color theme for KDE Plasma, GTK, Konsole and VS Code just use [Dracula theme](https://draculatheme.com).

System taskbar:
```
start|explorer|browser|discord|blender|clion|godot
```

Favorites in start menu:
- VS Code
- Gimp
- Thunderbird
- Xournal++
- directories shortcuts
- (variouse code editors?)

## Custom shortcuts

- `win+b` - open browser
- `win+m` - open discord
- `win+shift+q` - open up powerdown menu
- `prtsrn` - take rectangular spectacle screenshot to clipboard 

## Firefox

The main toolbar:
```
back|next|refresh|space|home|address bar|downloads|space|bookmarks|history|addons|menu
```

With installed addons (preferably shown right on toolbar):

- AdBlock Plus
- DownloadHelper
- UBlock Origin
- DarkReader

And three rows of web shortcuts on the default page:
```
Google|Maile|Ursynoteka|Sluis Van|Bastion|Gandalf|JWS|Ossus
YouTube|Translate|Moodle|USOS|Terminarz|lichess|chess.com|itch.io
adventofcode|roll20|github|rosalind|localhost|boardgames|reddit|wolfram
```

## Dolphin

Main toolbar:
```
back|next|up|sep|new|newdir|trash|addres|refresh|find|terminal|menu
```

Places:
- home
- desktop
- downloads
- Archives
- Projects
- rpg
- studia
- Trash

## Shell profile and environment variables

In user shell profile there should be some environment variables present:

- Standard XDG Base Directories ([link](https://wiki.archlinux.org/title/XDG_Base_Directory))
- Emscripten configuration variables so it follows standard configurations
- `KDEHOME` variable to put KDE configurations in place
- some variables for X11 (consult link above)
- set `ZDOTDIR=$HOME/.config/zsh` in `/etc/zsh/zshenv`

Additional custom environment variables:

- `$PROJECTS` - set to the full path to the Projects directory (`$HOME/Projects`)
- `$ARCHIVES` - set to the full path to the Archives directory (`$DATA_ROOT/Archives` or `$HOME/Archives`)
- `$SCRIPTS_ROOT` - set to the path to srcipts home directory (probably `$HOME/scripts`) and added to the `$PATH` variable