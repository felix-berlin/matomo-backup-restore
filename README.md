# Matomo backup

This script is aimed to use on shared hostings.

- [Matomo backup](#matomo-backup)
  - [General Informations](#general-informations)
  - [What do you need](#what-do-you-need)
  - [How to use this script](#how-to-use-this-script)
    - [Arguments](#arguments)
  - [Tested shared hostings](#tested-shared-hostings)

## General Informations

This bash script follows the official backup recommandations on matomo.org. Learn more in the [FAQ article](https://matomo.org/faq/how-to/how-do-i-backup-and-restore-the-matomo-data/).
The only thing i added is the add-drop-table option for mysqldump.

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

- After Cloning or downloading the repository you'll have to change the variable values in the .main.config.sh file. All values which need to be customized are marked with TODO in the script's comments
- You also have to customized the database credentials in the .database.config.cnf file. You can find your matomo credentials under /config/config.ini.php
- For security reasons I recommend to keep the repository files and backup files outside the public folder. The public folder is usually /var/www

### Arguments

$1 = backupMainDir

**Default:** /backup/matomo

---

$2 = pathToMatomo

**Default:** /html/matomo

---

Here is an Example:

```$ ./matomo_backup.sh /path/to/my/backup-folder /path/to/matomo```

## Tested shared hostings

- [x] Mittwald - Webhosting XL 11.0 - SSD
