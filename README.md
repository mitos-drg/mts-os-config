# Mitos Operating System Configuration

This repository contains detailed description of my personal operating system configuration (made with Arch Linux in mind) and varius scripts, utilities and even some configuration files both for it and for setting it up.

## Basic file structure

The basic file structure should mostly be the default one. With some exeptions to store most of not so often used data on a second drive (HDD). This secondary drive will be given the name `$DATA_ROOT` which will point to it's mounting point (most likely `/mnt/main`).

In order to prevent clutter as much files as possible should be moved following the XDG desktop scheme.

The Home directory structure:

```
$HOME
+ .config
+ Archives -> $DATA_ROOT/Archives
+ Books -> $DATA_ROOT/Books
+ Desktop
+ Documents -> $DATA_ROOT/Documents
+ Downloads
+ Music -> $DATA_ROOT/Music
+ Pictures -> $DATA_ROOT/Pictures
+ Projects
+ RPG -> $DATA_ROOT/RPG
+ Studia
+ Videos -> $DATA_ROOT/Videos
```

### Backup

On the backup drive there is flat directory hierarchy, basically the same as in the `$HOME` directory. Hovever it should be possible to perform quick or full data backup with just a single command, which will most likely be a script set up in a scripts home directory.

```
$BACKUP
+ .secrets
+ Archives
+ Books
+ Documents
+ Music
+ Pictures
+ Projects
+ RPG
+ Studia
+ Videos
```

Archives and Projects on the backup drive will mostly contain git repositories in a bare form (when possible). On the working machine both Projects and Archives will probably have repositories in expanded state (which may change for the Archives).

The backup process inside the backup script will depend on the rsync program for non-project files and on git for projects. In case of projects that for various reasons don't use git (or require more steps) they should provide `backup.sh` script (in project root or in project script directory).

## Shell profile and environment variables

Additional custom env variables:

- `$PROJECTS` - set to the full path to the Projects directory (`$HOME/Projects`)
- `$ARCHIVES` - set to the full path to the Archives directory (`$DATA_ROOT/Archives` or `$HOME/Archives`)
- `$SCRIPTS` - set to the path to srcipts home directory (probably `$HOME/scripts`) and added to the `$PATH` variable