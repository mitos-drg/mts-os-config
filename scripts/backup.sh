#!/usr/bin/bash

#
# USAGE: backup.sh
#


### BACK UP PROJECTS ###
$SCRIPTS_ROOT/backup/project-sync.sh

### BACK UP ARCHIVES ###
$SCRIPTS_ROOT/backup/archives-sync.sh


### TODO: BACK UP CONFIGURATIONS ###


### BACK UP PERSONAL DATA ###
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Documents $BACKUP/Documents
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Studia $BACKUP/Studia
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/RPG $BACKUP/RPG


### BACK UP MEDIA FILES ###
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Books $BACKUP/Books
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Music $BACKUP/Music
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Pictures $BACKUP/Pictures
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Videos $BACKUP/Videos