#!/bin/bash


#
# USAGE: cumulative-mirror.sh SRC DST
#
# where:
# - SRC - path to local source directory
# - DST - path to your backup directory
#
# This backup utility will perform custom designed semi-two-way
# directory synchronisation between SRC and DST. In usage SRC is your
# local directory and DST is your backup directory. Files will be pushed
# from SRC to DST but you will be prompted to confirm copy from DST to SRC
# in order to recognize deleted files.
# SRC and DST must be absolute paths
#

### UTILITIES ###
function log-info {
    echo "`date "+%H:%M:%S"` [ \e[34mINFO\e[0m ]:" "$@"
}

function log-error {
    echo "`date "+%H:%M:%S"` [ \e[31mERROR\e[0m ]:" "$@"
}


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