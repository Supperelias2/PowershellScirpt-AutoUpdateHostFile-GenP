# IN development branch for menu addition !!!

# Automation Script for GenP

This PowerShell script automates the process of updating your `hosts` file to block Adobe licensing validation servers. The script performs the following steps:

1. **Checks Write Access:** Verifies if the `hosts` file is writable by the current user.
2. **Backup Creation:** Creates a backup of the existing `hosts` file in `C:\Temp` before making any changes.
3. **Download and Update:** Downloads the latest entries from a specified URL and **overwrites** your `hosts` file with this content if the download is successful.

**Important:** Ensure that your user account has Modify access to the `hosts` file in Windows to allow the script to make the necessary changes.

For more information on GenP, check out the wiki & guides @ [/r/GenP](https://www.reddit.com/r/GenP).
