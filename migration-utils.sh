export BACKUP=/run/media/mitos/Miko_Kopie
export BACKUP_DATA=$BACKUP/miko

export DATA_ROOT=/home/mitos

# rsync -av SRC DEST

function rsync-recursive {
    pushd $1
    rsync -dlptgov ./ $2
    find . -maxdepth 1 -type d -not -name "." -exec rsync -rlptgov {} $2 \;
    popd
}

function rsync-recursive-try {
    pushd $1
    rsync -dlptgovn ./ $2
    find . -maxdepth 1 -type d -not -name "." -exec rsync -rlptgovn {} $2 \;
    popd
}

# Unity, UnrealEngine, VisualStudio, Python
function pull-gitignore {
    pushd $2
    local tool=$1
    curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/main/$tool.gitignore
    popd
}

function git-pack {
    # Create target bare repository and delete old one
    git clone --bare $1 $1.git
    rm -rf $1
    
    # Remove bare repository remotes
    pushd $1.git
    git remote remove origin
    popd
}

function git-unpack {
    git clone $1
    
    # Remove repository
    pushd ${1%.git}
    rm -rf .git/
    popd
    
    rm -rf $1
}

function archivize-project {
    # Change into processing project's directory
    local project=$1
    pushd $project
    
    # Create git repository
    if [ ! -d .git ]; then
        git init
    fi
    
    git add .
    git commit -m "Create archive git repository of $project."
    
    popd
    
    git-pack $project
}


# list of directories to pull
# 
# rsync-recursive $BACKUP_DATA/Books $DATA_ROOT/Books
# rsync-recursive $BACKUP_DATA/Documents $DATA_ROOT/Documents
# rsync-recursive $BACKUP_DATA/RPG $DATA_ROOT/RPG
# rsync-recursive $BACKUP_DATA/Studia $DATA_ROOT/Studia
# rsync-recursive $BACKUP_DATA/Muzyka $DATA_ROOT/Music/Muzyka
# rsync-recursive $BACKUP_DATA/Filmy/Filmy $DATA_ROOT/Videos/Filmy
# rsync-recursive $BACKUP_DATA/Filmy/Video $DATA_ROOT/Videos/Video
# rsync-recursive $BACKUP_DATA/Filmy/Animacje $DATA_ROOT/Videos/Animacje
