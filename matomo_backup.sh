#!/bin/bash

#
# Bash script for creating backups of Matomo.
#
# Version 1.0.0
#
# Usage:
# 	- With backup directory specified in the script:  ./MatomoBackup.sh
# 	- With backup directory specified by parameter: ./MatomoBackup.sh <BackupDirectory> (e.g. ./MatomoBackup.sh /media/hdd/Matomo_backup)
#
# The script is based on an installation of Matomo using nginx and MariaDB, see https://decatec.de/home-server/Matomo-auf-ubuntu-server-18-04-lts-mit-nginx-mariadb-php-lets-encrypt-redis-und-fail2ban/
#

#
# IMPORTANT
# You have to customize this script (directories, users, etc.) for your actual environment.
# All entries which need to be customized are tagged with "TODO".
#

# Variables
backupMainDir=$1

if [ -z "$backupMainDir" ]; then
	# TODO: The directory where you store the Matomo backups (when not specified by args)
    backupMainDir='../matomo'
fi

currentDate=$(date +"%Y%m%d_%H%M%S")

# The actual directory of the current backup - this is a subdirectory of the main directory above with a timestamp
backupdir="${backupMainDir}/${currentDate}/"

# TODO: The directory of your Matomo installation (this is a directory under your web root)
pathToMatomo='/html/matomo'

matomoBackupFiles='.htaccess robots.txt config/config.ini.php plugins/'

# TODO: The service name of the web server. Used to start/stop web server (e.g. 'systemctl start <webserverServiceName>')
webserverServiceName='apache'

# TODO: Your web server user
webserverUser='root'

# TODO: The name of the database system (ome of: mysql, mariadb, postgresql)
databaseSystem='mysql'

# TODO: Your Matomo database name
matomoDatabase='databaseName'

# TODO: Your Matomo database host
dbHost='localhost'

# TODO: Your Matomo database user
dbUser='databaseUser'

# TODO: The password of the Matomo database user
dbPassword='my_P@SsworD'

# TODO: The maximum number of backups to keep (when set to 0, all backups are kept)
maxNrOfBackups=12

# File names for backup files
nameBackupFileDir="${currentDate}_matomo-data.tar.gz"

fileNameBackupDb="${currentDate}_matomo-db.sql"

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
if [ "${databaseSystem,,}" = "mysql" ] || [ "${databaseSystem,,}" = "mariadb" ]; then
		echo
  	echo "Backup Matomo database (MySQL/MariaDB)..."

	if ! [ -x "$(command -v mysqldump)" ]; then
		errorecho "ERROR: MySQL/MariaDB not installed (command mysqldump not found)."
		errorecho "ERROR: No backup of database possible!"
	else
		mysqldump --extended-insert --no-autocommit --quick --single-transaction --add-drop-database -h "${dbHost}" -u "${dbUser}" -p"${dbPassword}" "${matomoDatabase}" > "${backupdir}/${fileNameBackupDb}"

		echo
		echo "Compress database backup with tar and gzip..."
		tar -cpzf "${backupdir}/${currentDate}_matomo-db.tar.gz" -C ${backupdir} ${fileNameBackupDb}

		echo
		echo "Delete uncompressed database backup file"
		rm "${backupdir}/${fileNameBackupDb}"
	fi

	echo "Done"
	echo
elif [ "${databaseSystem,,}" = "postgresql" ]; then
	echo "Backup Matomo database (PostgreSQL)..."

	if ! [ -x "$(command -v pg_dump)" ]; then
		errorecho "ERROR:PostgreSQL not installed (command pg_dump not found)."
		errorecho "ERROR: No backup of database possible!"
	else
		PGPASSWORD="${dbPassword}" pg_dump "${nextcloudDatabase}" -h localhost -U "${dbUser}" -f "${backupdir}/${fileNameBackupDb}"
	fi

	echo "Done"
	echo
fi


echo
echo "DONE!"
echo "Backup created: ${backupdir}"

#
# Backup matomo
#
echo "Creating Matomo backup..."
tar -cpzf "${backupdir}/${nameBackupFileDir}" -C "${pathToMatomo}" ${matomoBackupFiles}

echo "Done"
echo

#
# Delete old backups
#
if [ ${maxNrOfBackups} != 0 ]
then
	nrOfBackups=$(ls -l ${backupMainDir} | grep -c ^d)

	if [[ ${nrOfBackups} > ${maxNrOfBackups} ]]
	then
		echo "Removing old backups..."
		ls -t ${backupMainDir} | tail -$(( nrOfBackups - maxNrOfBackups )) | while read -r dirToRemove; do
			echo "${dirToRemove}"
			rm -r "${backupMainDir}/${dirToRemove:?}"
			echo "Done"
			echo
		done
	fi
fi