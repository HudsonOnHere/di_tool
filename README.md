# di_tool
a bash tool written to simplify data migrations in macOS when time machine and/or migration assistant may not be suitable

# Best Practices for Use:
- this tool should only be run AFTER fully setting up a new user account
  - you should make sure to launch all of the default apps once the account is set up (Safari, Contacts, Mail, Calendar, Photos, etc.)
  - this will populate the application dependencies in ~/Library that make the default Apple apps function
  - rsync may fail if these folders are not created before di_tool is run

# Scope:
- this tool is scripted to work for transferring data between volumes on a local machine, however rsync can be modified to transfer files remotely as well
- currently, this tool transfers only default home folders and data from default Apple applications only
  - ie, Desktop, Documents, Downloads, Movies, Music, and Pictures folders
  - if there are additional folders you would like to transfer, you will have to add them in to the rsync functions at the end of the script
  - ex. $ sudo rsync -avrz "$src/Destkop" ... "$src/Pictures" "$src/mu_code" "$src/Adobe Creative Cloud" "$src/Other Folder" "$tgt/"
  - we added "mu_code", "Adobe Creative Cloud", and "Other Folder" here
  - rsync will take whatever directories you give it and transfer them all to the last one in the list, in this case "$tgt/" (the target home folder)
  - for more information about rsync, run 'man rsync'
- manual data integrations are not a perfect science, this tool was written with the express goal in mind of making them a bit simpler
- when moving between different versions of macOS, you may run into issues with library compatibilty (Photos app) or with iTunes vs Music app
- some types of data (Mail, Calendars) may appear not take to the new account after transfer until you sign in with the same internet account that the application data is linked to

# Additional Notes:
- this tool is a work in progress, so feel free to reach out with any comments/suggestions
- feel free to share this script if you find it useful and make sure to credit me
