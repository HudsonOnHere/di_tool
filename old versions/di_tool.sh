#! /bin/bash

clear

# Get source volume
echo
echo "Please enter the name of the volume where your data is located (case-sensitive)"
echo
ls /Volumes/
echo
read -p "Source Volume: " SVOL
clear
echo
echo "You entered" $SVOL
echo

# Get source home folder
echo "Please enter your home folder's name from the list below (case-sensitive)"
echo
ls /Volumes/"$SVOL"/Users/
echo
read -p "Home folder: " SRC_USER
clear

# Define path to source user's home folder
SOURCE_HOME=$(echo -n "/Volumes/$SVOL/Users/$SRC_USER")

echo
echo "Your home folder is located at:" $SOURCE_HOME
echo

# Get target volume
echo
echo "Please enter the name of the volume where your data will be transferred (case-sensitive)"
echo
ls /Volumes/
echo
read -p "Target Volume: " TVOL
clear

echo
echo "You entered" $TVOL
echo

# Get source home folder
echo "Please enter your NEW home folder's name from the list below (case-sensitive)"
echo
ls /Volumes/"$TVOL"/Users/
echo
read -p "Home folder: " TGT_USER
clear

# Define path to source user's home folder
TARGET_HOME=$(echo -n "/Volumes/$TVOL/Users/$TGT_USER")

echo "Your destination home folder is located at:" $TARGET_HOME
echo

# User prompted to continue or exit
while true; do
	read -p "Looks like you're all set. Ready to begin? (y/n)" -n 1 YN
	case $YN in
		[Yy]* ) clear; echo; echo "Okay, here we go..."; echo; break;;
		[Nn]* ) exit;;
		* ) clear;
		echo;
		echo "Oops, try again (y/n)";
		echo;;
	esac
done


# Bulk data transfer from default home folders
sudo rsync -avrz "$SOURCE_HOME/Destkop" "$SOURCE_HOME/Documents" "$SOURCE_HOME/Downloads" "$SOURCE_HOME/Movies" "$SOURCE_HOME/Music" "$SOURCE_HOME/Pictures" "$TARGET_HOME/"

# Delete new application dependencies
sudo rm -rf "$TARGET_HOME/Library/Safari" "$TARGET_HOME/Library/Calendars" "$TARGET_HOME/Library/Mail" "$TARGET_HOME/Library/Application\ Support/AddressBook"

# Rebuild old application dependencies
sudo rsync -avrz "$SOURCE_HOME/Library/Safari" "$SOURCE_HOME/Library/Calendars" "$SOURCE_HOME/Library/Mail" "$TARGET_HOME/Library/" && sudo rsync -avrz "$SOURCE_HOME/Library/Application\ Support/AddressBook" "$TARGET_HOME/Library/Application\ Support/AddressBook"

