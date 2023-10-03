#!/usr/bin/bash

# The automated backup system for my files. All that has to be done to perform
# the backup is typing out this single command.


### UTILIETIES ###

function log-info {
    echo "`date "+%H:%M:%S"` [ \e[34mINFO\e[0m ]: " "$@"
}

function log-warning {
    echo "`date "+%H:%M:%S"` [ \e[33mWARNING\e[0m ]: " "$@"
}

function log-error {
    echo "`date "+%H:%M:%S"` [ \e[31mERROR\e[0m ]: " "$@"
}


### BACKUP FUNCTIONS ###

## Archives ##
function backup-archives {
    # Change directory into $ARCHIVES
    pushd $ARCHIVES
    log-info "Starting backup process of Archives..."
    
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
        # Go into project directory
        pushd $project
        log-info "Making backup of $project..."
        
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
