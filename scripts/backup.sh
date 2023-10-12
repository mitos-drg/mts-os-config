#!/usr/bin/bash

#
# USAGE: backup.sh
#


### BACK UP PROJECTS ###
$SCRIPTS_ROOT/backup/projects-sync.sh

### BACK UP ARCHIVES ###
$SCRIPTS_ROOT/backup/archives-sync.sh


### TODO: BACK UP CONFIGURATIONS ###
#$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/config $BACKUP/config
#$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/secrets $BACKUP/secrets


### BACK UP PERSONAL DATA ###
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Documents $BACKUP/Documents
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Studia $BACKUP/Studia
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/RPG $BACKUP/RPG


### BACK UP MEDIA FILES ###
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Books $BACKUP/Books
#$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Games $BACKUP/Games
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Music $BACKUP/Music
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Pictures $BACKUP/Pictures
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Videos/Movies $BACKUP/Videos/Filmy
$SCRIPTS_ROOT/backup/cumulative-mirror.sh $DATA_ROOT/Videos/Videos $BACKUP/Videos/Video