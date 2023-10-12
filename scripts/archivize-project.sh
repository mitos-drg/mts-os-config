#!/bin/bash


#
# USAGE: archivize-project.sh PROJECT
#
# This command line utility handles the archivization process of a project.


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

# Set up variables
project=$1

# Clone (or copy) project into Archives directory
if [ -d "$PROJECTS/$project/.git" ]; then
    log-info "Git repository detected, cloning into Archives..."
    git clone "$PROJECTS/$project" "$ARCHIVES/$project"
    pushd "$ARCHIVES/$project"
    git remote remove origin
    popd
else
    log-info "Project not configured with git, performing copy..."
    rsync -au "$PROJECTS/$project" "$ARCHIVES"
fi

# Ask to delete leftover project directory
printf "$project copied to Archives, do you want to delete local files [Y/n]? "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then 
    log-info "Cleaning local project files..."
    rm -rf "$PROJECTS/$project"
fi

log-info "$project successfully archivized."
