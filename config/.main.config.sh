#!/bin/bash

#
# IMPORTANT
# You have to customize this script (directories etc.) for your actual environment.
# All entries which need to be customized are tagged with "TODO".
#

echo "Load config: ${0}"

# Variables
backupMainDir=$1

if [ -z "$backupMainDir" ]; then
	# TODO: The directory where you store the Matomo backups (when not specified by args)
    backupMainDir='/backup/matomo'
fi

currentDate=$(date +"%Y%m%d_%H%M%S")

# The actual directory of the current backup - this is a subdirectory of the main directory above with a timestamp
backupdir="${backupMainDir}/${currentDate}/"

pathToMatomo=$2

if [ -z "$pathToMatomo" ]; then
# TODO: The directory of your Matomo installation (this is a directory under your web root)
pathToMatomo='/html/matomo'
fi

# TODO: You may wish to backup some other files
matomoBackupFiles='.htaccess robots.txt config/config.ini.php plugins/'

# TODO: The maximum number of backups to keep (when set to 0, all backups are kept)
maxNrOfBackups=12

# File names for backup files
nameBackupFileDir="${currentDate}_matomo-data.tar.gz"

fileNameBackupDb="${currentDate}_matomo-db.sql"

#
# Database config
#
# IMPORTANT
# Make sure to customize all entries under [client] in the database.config.cnf
#

# TODO: Your Matomo database name
matomoDatabase='myMatomoDatabaseName'

