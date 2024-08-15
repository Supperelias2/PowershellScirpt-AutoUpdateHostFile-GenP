# Automation Script for GenP

This PowerShell script automates the process of updating your `hosts` file to block Adobe licensing validation servers. The script performs the following steps:

1. **Administrator Rights Check:** The script ensures that it is run with elevated (administrator) rights. If not, it will restart itself with the necessary privileges.

2. **Menu-Driven Interface:** Provides a user-friendly menu for different operations related to the `hosts` file.

3. **Check Write Access:** Verifies if the `hosts` file is writable by the current user, ensuring that modifications can be made.

4. **Backup Creation:** Creates a timestamped backup of the existing `hosts` file in `C:\Temp\hostsbackup\` before making any changes.

5. **Download and Update:** Downloads the latest entries from a specified URL and **overwrites** your `hosts` file with this content if the download is successful.

6. **Exit Option:** Allows you to exit the script gracefully.

## Usage

1. **Run the Script**: Simply execute the script in PowerShell. The script will automatically check for administrator rights and restart with elevated privileges if necessary.

2. **Select an Option**: Use the menu to choose whether to check the write status of the `hosts` file, create a backup, or update the `hosts` file with new entries.

3. **Backup and Update**: If you choose to update the `hosts` file, a backup will be created first in `C:\Temp\hostsbackup\` with a timestamped filename.

**Important:** Ensure that your user account has modify access to the `hosts` file in Windows to allow the script to make the necessary changes.

## Script Structure

### Variables
The script uses the following variables for easy configuration:

- **`$hostsPath`**: The path to your `hosts` file. Typically, this is `C:\Windows\System32\drivers\etc\hosts`.
- **`$backupPath`**: The directory where backups of the `hosts` file will be stored.
- **`$url`**: The URL from which the new `hosts` file entries will be downloaded.

### Functions

#### `Check-AdministratorRights`
This function checks if the script is being run as an administrator. If not, it restarts the script with elevated privileges.

#### `Show-Menu`
Displays a menu with options to check the write status of the `hosts` file, create a backup, update the `hosts` file, or exit the script.

#### `Check-HostFileWriteStatus`
Checks if the `hosts` file is writable. If the file is read-only, it informs the user that they need to change the permissions.

#### `Backup-CurrentHostFile`
Creates a timestamped backup of the current `hosts` file in the specified backup directory. Ensures the backup directory exists before attempting to create the backup.

#### `Update-HostFile`
Downloads the latest `hosts` file entries from the specified URL and overwrites the current `hosts` file with this content, provided the file is writable.

#### `Exit-Script`
Exits the script.

For more information on GenP, check out the wiki & guides at [/r/GenP](https://www.reddit.com/r/GenP).
