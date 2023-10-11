# Basic file structure

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
+ Studia -> $DATA_ROOT/Studia
+ Videos -> $DATA_ROOT/Videos
```

```
$DATA_ROOT
+ Archives
+ Books
+ Documents
+ Music
+ Pictures
+ RPG
+ Studia 
+ Videos 
| + Movies
| + Videos
```

```
$DATA_STORAGE
+ Instale
+ Projects
```

## Drives and mount points

As number of physical drives may vary between my diffrent systems they should be mounted hovewer it makes sense for theme and instead of reling on consistent paths and volume names file organisation should be dependant on some environment variables. Moreover I propose to keep as much as possible the following principle: one physical disk, one partition.

The main (system one) drive should be without a doubt mountet simply as *root* (`/`). The main user home directory should be left at its default location in `/home/user`, and per usual the `$HOME` environment variable will point to it. I decided, that this home directory shouldn't be placed on separate partition, but just on the system one.

Main data drive (if diffrent than system drive) should be mounted in place like `/mnt/data-main` and it would be reffered to as `$DATA_ROOT`. This variable will be the base directory for most bulk data storage, such as *Documents*, *Movies*, *Pictures*, *Music*, *Books* and potentially *Archives* (which should be rather reffered to as `$ARCHIVES`).

The `$DATA_STORAGE` mount point should be generally for non-personal, more static and/or less important data. But it may also hold immidiate backup copy of Projects.

## Backup

On the backup drive there is flat directory hierarchy, basically the same as in the `$HOME` directory. Hovever it should be possible to perform quick or full data backup with just a single command, which will most likely be a script set up in a scripts home directory.

This external backup drive should be mounted and accessed simply as a `$BACKUP`, to allow more flexibility in mounting it across various systems.

```
$BACKUP
+ .secrets
+ Archives
+ Books
+ Documents
+ Games
+ Music
+ Pictures
+ Projects
+ RPG
+ Studia
+ Videos
```

Archives and Projects on the backup drive will mostly contain git repositories in a bare form (when possible). On the working machine both Projects and Archives will probably have repositories in expanded state (which may change for the Archives).

The backup process inside the backup script will depend on the rsync program for non-project files and on git for projects. In case of projects that for various reasons don't use git (or require more steps) they should provide `backup.sh` script (in project root or in project script directory).