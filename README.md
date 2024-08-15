# Automation Script for GenP

This PowerShell script automates the process of updating your `hosts` file to block Adobe licensing validation servers. 

## How To Uuse

1. **Run the Script**: Execute the script in PowerShell. The script will first check for administrator rights and restart with elevated privileges if necessary.

2. **Select an Option**: Use the menu to choose an operation. It is recommended to follow the options in sequence: first, check the write status of the `hosts` file to ensure you have the necessary permissions, then create a backup, and finally update the `hosts` file with new entries.

3. **Update**: Before updating the `hosts` file, it is recommended to manually create a backup using the provided option. This ensures that your original `hosts` file is preserved before any changes are made. The backup will be saved in `C:\Temp\hostsbackup\` with a timestamped filename.

**Important:** Ensure that your user account has modify access to the `hosts` file in Windows to allow the script to make the necessary changes.

## Script Structure

### Variables

The script uses the following variables for easy configuration:

- **`$hostsPath`**: The path to your `hosts` file. Typically, this is `C:\Windows\System32\drivers\etc\hosts`.
- **`$backupPath`**: The directory where backups of the `hosts` file will be stored.
- **`$url`**: The URL from which the new `hosts` file entries will be downloaded.

For more information on GenP, check out the wiki & guides at [/r/GenP](https://www.reddit.com/r/GenP).
