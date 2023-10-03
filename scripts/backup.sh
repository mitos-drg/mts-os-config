#!/usr/bin/bash

# The automated backup system for my files. All that has to be done to perform
# the backup is typing out this single command.


### UTILITIES ###

function log-info {
    echo "`date "+%H:%M:%S"` [ \e[34mINFO\e[0m ]:" "$@"
}

function log-warning {
    echo "`date "+%H:%M:%S"` [ \e[33mWARNING\e[0m ]:" "$@"
}

function log-error {
    echo "`date "+%H:%M:%S"` [ \e[31mERROR\e[0m ]: ""$@"
}


### BACKUP FUNCTIONS ###

## Back up cumulative ##
function backup-cumulative {
    # This backup utility function will perform custom designed semi-two-way
    # directory synchronisation between SRC and DST. In usage SRC is your
    # local directory and DST is your backup directory. Files will be pushed
    # from SRC to DST but you will be prompted to confirm copy from DST to SRC
    # in order to recognize deleted files.
    # SRC and DST must be absolute paths
    
    # Set up variables
    SRC=$1
    DST=$2
    
    log-info "Starting synchronization $SRC <-> $DST..."
    
    # Step into SRC directory
    pushd $SRC
    
    # Syncronise files only
    rsync -dlptgov ./ $DST
    
    # Iterate over it's content
    for dir in *
    do
        # Skip all files
        if [ -f $dir ]; then
            continue
        fi
        
        # Pull directory content if it exists in DST
        if [ -d $DST/$dir ]; then
            rsync -a $DST/$dir/ $SRC/$dir
        fi
        
        # Push local content
        rsync -a $SRC/$dir $DST
    done
    
    # Step into DST directory
    popd
    pushd $DST
    
    # Iterate over DST contents
    for dir in *
    do
        # Check if this directory exists only on DST
        if [ ! -e $SRC/$dir ]; then
            # Ask whether to copy or not (deletions users should manage manually)
            printf "$dir is missing from $SRC, do you want to copy it [Y/n]? "
            read answer

            if [ "$answer" != "${answer#[Yy]}" ]; then 
                rsync -a $DST/$dir $SRC
            fi
        fi
    done
    
    # Return to the original directory
    popd
    log-info "Syncronization $SRC <-> $DST completed."
}

## Archives ##
function backup-archives {
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
                rsync -a $BACKUP/Archives/$project/. $ARCHIVES/$project
            fi
            
            # Push local changes
            rsync -a $ARCHIVES/$project $BACKUP/Archives
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
                    rsync -a $BACKUP/Archives/$project/. $ARCHIVES/$project
                fi
            fi
        fi
    done
    
    # Return to the original directory
    popd
    log-info "Archives backup complete."
    echo
}

## Projects ##
function backup-projects {
    # Change directory into $PROJECTS
    pushd $PROJECTS
    log-info "Starting backup process of Projects..."
    
    # Handle all directories
    for project in *
    do
        # Check if we accidentally hit a file
        if [ -f $project ]; then
            log-error "$project is a file, not directory!"
            continue
        fi
        log-info "Making backup of $project..."
        
        # Go into project directory
        pushd $project
        
        # Check if it is git-based and backup it using git if so
        if [ -d .git ]; then
            # Create backup repository if it doesn't exist
            if [ ! -d $BACKUP/Projects/$project.git ]; then
                # Warn user about auto-generating backup repository
                log-warning "$project doesn't have backup repository. Creating..."
                
                # Clone repository as a bare one
                pushd $BACKUP/Projects
                git clone --bare $PROJECTS/$project $project.git
                cd $project.git
                git remote remove origin
                popd
                
                # Set up local remotes
                git remote add backup $BACKUP/Projects/$project.git
            fi
            
            # Push all local changes to backup repository
            git pull backup
            git push --all --tags backup
            
        # Not git-based projects should specify their of backup strategies with
        # eighter backup.sh or scripts/backup.sh
        else
            if [ -f backup.sh ]; then
                ./backup.sh
            elif [ -f scripts/backup.sh ]; then
                scripts/backup.sh
            else
                log-error "Project $project doesn't have backup strategy!"
            fi
        fi
        
        # Return into $PROJECTS directory
        popd
    done
    
    # Return to the script execution directory
    popd
    log-info "Projects backup complete."
    echo
}
