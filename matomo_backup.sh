#!/bin/bash

#
# Bash script for creating backups of Matomo.
#
# Version 1.1.1
#

#
# IMPORTANT
# You have to customize the following config files: .main.config.sh and .database.config.cnf
#

. config/.main.config.sh

# Function for error messages
errorecho() { cat <<< "$@" 1>&2; }

#
# Print information
#
echo "Backup directory: ${backupMainDir}"


#
# Check if backup dir already exists
#
if [ ! -d "${backupdir}" ]
then
	mkdir -p "${backupdir}"
else
	errorecho "ERROR: The backup directory ${backupdir} already exists!"
	exit 1
fi

#
# Backup DB
#
echo
echo "1. Backup Matomo database (MySQL/MariaDB)..."

if ! [ -x "$(command -v mysqldump)" ]; then
	errorecho "ERROR: MySQL/MariaDB not installed (command mysqldump not found)."
	errorecho "ERROR: No backup of database possible!"
else
	mysqldump --defaults-extra-file=config/.database.config.cnf "${matomoDatabase}" > "${backupdir}/${fileNameBackupDb}"

	echo
	echo "1.1 Compress database backup with tar and gzip..."
	tar -cpzf "${backupdir}/${currentDate}_matomo-db.tar.gz" -C ${backupdir} ${fileNameBackupDb}
	echo "Compress database completed!"

	echo
	echo "1.2 Delete uncompressed database backup file"
	rm "${backupdir}/${fileNameBackupDb}"
	echo "Delete uncompressed database backup completed!"
fi

echo
echo "Database backup completed!"
echo

#
# Backup matomo
#
echo "2. Backup Matomo's files..."
tar -cpzf "${backupdir}/${nameBackupFileDir}" -C "${pathToMatomo}" ${matomoBackupFiles}
echo "File backup completed!"
echo

#
# Delete old backups
#
if [ ${maxNrOfBackups} != 0 ]
then
	nrOfBackups=$(ls -l ${backupMainDir} | grep -c ^d)

	if [[ ${nrOfBackups} > ${maxNrOfBackups} ]]
	then
		echo "3. Removing old backups..."
		ls -t ${backupMainDir} | tail -$(( nrOfBackups - maxNrOfBackups )) | while read -r dirToRemove; do
			echo "${dirToRemove}"
			rm -r "${backupMainDir}/${dirToRemove:?}"
			echo "Removing old backups completed!"
			echo
		done
	fi
fi

echo
echo "DONE!"
echo "Backup created: ${backupdir}"