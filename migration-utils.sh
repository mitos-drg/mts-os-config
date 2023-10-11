export BACKUP=/mnt/backup
export BACKUP_DATA=$BACKUP/miko
export SCRIPTS_ROOT=/home/mitos/Projects/mts-os-config/scripts

export DATA_ROOT=/home/mitos
export PROJECTS=/Projects
export ARCHIVES=/Archives

# rsync -av SRC DEST
# printf 'Is this a good question (y/n)? '
# read answer

# if [ "$answer" != "${answer#[Yy]}" ] ;then 
#     echo Yes
# else
#     echo No
# fi


function rsync-recursive {
    pushd $1
    rsync -dlptgouv ./ $2
    find . -maxdepth 1 -type d -not -name "." -exec rsync -rlptgov {} $2 \;
    popd
}

function rsync-recursive-try {
    pushd $1
    rsync -dlptgovun ./ $2
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

function pull-archives {
    # Change directory into Archives backup and look for not covered projects
    pushd $BACKUP/Archives
    for project in *
    do
        # Remove .git extension, if it exists
        basename=${project%.git}
        
        # Check if it does not exist in local Archive
        log-info "Copying $basename into local Archive..."
        if [ "$project" == *.git ]; then
            pushd $ARCHIVES
            git clone -o backup "$BACKUP/Archives/$project"
            popd
        else
            mkdir "$ARCHIVES/$project"
            rsync -au "$BACKUP/Archives/$project/." "$ARCHIVES/$project"
        fi
    done

    # Return to the original directory
    popd
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
