#!/bin/bash


#
# USAGE: archives-sync.sh
#
# This is utility script for backups of $ARCHIVES directory.
#

### UTILITIES ###
function log-info {
    echo -e "`date "+%H:%M:%S"` [ \e[34mINFO\e[0m ]:" "$@"
}

function log-warning {
    echo -e "`date "+%H:%M:%S"` [ \e[33mWARNING\e[0m ]:" "$@"
}

function log-error {
    echo -e "`date "+%H:%M:%S"` [ \e[31mERROR\e[0m ]: ""$@"
}


# Change directory into $ARCHIVES
pushd $ARCHIVES
log-info "Starting backup process of Archives..."

# Iterate over all directories in Archives
for project in *
do
    # Check if we accidentally hit a file
    if [ -f $project ]; then
        log-error "$project is a file, not directory!"
        continue
    fi
    log-info "Making backup of $project..."
    
    # Check if it is git-based project
    if [ -d $project/.git ]; then
        # Create backup repository if it doesn't exist
        if [ ! -d $BACKUP/Archives/$project.git ]; then
            # Warn user about auto-generating backup repository
            log-warning "$project doesn't have backup repository. Creating..."
            
            # Clone repository as a bare one
            pushd $BACKUP/Archives
            git clone --bare $ARCHIVES/$project $project.git
            cd $project.git
            git remote remove origin
            popd
            
            # Set up local remotes
            git remote add backup $BACKUP/Archives/$project.git
        fi
        
        # Push all local changes to backup repository
        pushd $project
        git pull backup
        git push --all --tags backup
        popd
    
    # Non git-based archival projects are simply backed up with rsync
    else
        # Pull, if project exists in archives (push will create it otherwise)
        if [ -d $BACKUP/Archives/$project ]; then
            rsync -au $BACKUP/Archives/$project/. $ARCHIVES/$project
        fi
        
        # Push local changes
        rsync -au $ARCHIVES/$project $BACKUP/Archives
    fi
done

# Change directory into Archives backup and look for not covered projects
cd $BACKUP/Archives
for project in *
do
    # Remove .git extension, if it exists
    basename=${project%.git}
    
    # Check if it does not exist in local Archive
    if [ ! -d $ARCHIVES/$basename ]; then
        printf "$basename is missing from local Archives.\nWould you like to copy it [y/n]? "
        read answer
        
        if [ "$answer" != "${answer#[Yy]}" ] ;then 
            log-info "Copying $basename into local Archive..."
            if [ $project == *.git ]; then
                pushd $ARCHIVES
                git clone -o backup $BACKUP/Archives/$project
                popd
            else
                mkdir $ARCHIVES/$project
                rsync -au $BACKUP/Archives/$project/. $ARCHIVES/$project
            fi
        fi
    fi
done

# Return to the original directory
popd
log-info "Archives backup complete."
echo