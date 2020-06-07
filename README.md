# Matomo (Piwik) backup and restore

This script is aimed to use on shared hosting's.

Table of Contents:

- [Matomo (Piwik) backup and restore](#matomo-piwik-backup-and-restore)
  - [General information's](#general-informations)
  - [What do you need](#what-do-you-need)
  - [How to use this script](#how-to-use-this-script)
    - [Arguments](#arguments)
  - [How to restore a backup](#how-to-restore-a-backup)
  - [Tested shared hosting's](#tested-shared-hostings)
  - [Roadmap](#roadmap)

## General information's

This bash script follows the official backup recommendations on matomo.org. Learn more in the [FAQ article](https://matomo.org/faq/how-to/how-do-i-backup-and-restore-the-matomo-data/).
The only thing I added is the add-drop-table option for mysqldump.

**The script does the following steps:**

1. Backup Matomo database (MySQL/MariaDB)
2. Compress database backup with tar and gzip
3. Delete uncompressed database backup file
4. Backup Matomo's files
5. Removing old backups

## What do you need

- **NO root access. Yeh!**
- Terminal access
- The tar extension

## How to use this script

- After Cloning or downloading the repository duplicate both config files and rename it so that ".example" is removed. Now the config files are no longer tracked by git.
- Then you'll have to change the variable values in the .main.config.sh file. All values which need to be customized are marked with TODO in the script's comments.
- You also have to customized the database credentials in the .database.config.cnf file. You can find your Matomo credentials under /config/config.ini.php
- For security reasons I recommend to keep the repository files and backup files outside the public folder. The public folder is usually /var/www
- When you have customized the config files you can do both, make a manually backup or create automatic backups via a cronjob

### Arguments

$1 = backupMainDir

**Default:** /backup/matomo

---

$2 = pathToMatomo

**Default:** /html/matomo

---

Here is an example:

```$ ./matomo_backup.sh /path/to/my/backup-folder /path/to/matomo```

## How to restore a backup

1. Import the Mysql backup data in a new Mysql database you have created
2. Download the latest version of Matomo, unzip and upload
3. Copy the file config.ini.php from the backup into your new Matomo setup. You might have to edit the database connection settings in the file if they have changed.
4. Copy any Third party Plugin installed from the Marketplace from the backup (or download from the marketplace the latest version of these plugins) and copy them into your new Matomo setup.
5. Copy all the other files you have saved with the script
6. Visit Matomo and check that everything is working correctly!

In the future there will be a restore bash script. (See [roadmap](#roadmap))

## Tested shared hosting's

- [x] Mittwald - Webhosting XL 11.0 - SSD

## Roadmap

- [ ] A script to automatic restore a backup file
- [ ] Finding a more secure solution to store database credentials
- [ ] Save backups on remote server via SSH
