#!/bin/bash

clear
echo
echo "di_tool 0.4.2 -- by Rich Wright"
echo
echo "run me as root or you will be prompted to enter your password"
echo

# stage1 assigns the paths to the source for data transfer
function stage1 {
# source volume assigned
echo
echo "Where is your data located?"
echo
cd /Volumes/
PS3='Enter your source volume: '
select source_vol in *;
	do
		case $source_vol in
			*)		
				clear;
				echo
				echo "You picked " $source_vol;
				echo;
				break
				;;
		esac
	done

# source home folder assigned
echo
echo "Which user's data would you like to transfer?"
echo
cd "/Volumes/$source_vol/Users/"
PS3='Enter your source home folder: '
select source_user in *;
	do
		case $source_user in
			*)		
				clear;
				echo;
				echo "You picked " $source_user;
				echo;
				break
				;;
		esac
	done
# final path to the source home folder
src=$(echo -n "/Volumes/$source_vol/Users/$source_user")

}

# stage2 assigns the paths to the destination for data transfer
function stage2 {
# target volume assigned
echo
echo "Where is your data going?"
echo
cd /Volumes/
PS3='Enter your destination volume: '
select target_vol in *;
	do
		case $target_vol in
			*)
				clear;
				echo
				echo "You picked " $target_vol
				echo;
				break
				;;
		esac
	done

# target home folder assigned
echo
echo "Which user is going to recieve this data?"
echo
cd "/Volumes/$target_vol/Users/"
PS3='Enter your destination home folder: '
select target_user in *;
	do
		case $target_user in
			*)
				clear;
				echo
				echo "You picked " $target_user
				echo;
				break
				;;
		esac
	done
# final path to the destination home folder
tgt=$(echo -n "/Volumes/$target_vol/Users/$target_user")

}

stage1

clear
echo
echo "You are going to transfer $source_user's data

You can enter Y to continue, N to start over, or Q to quit"
while true; do
	read -p "Continue?" -n 1 yn
		case $yn in
			[Yy]) stage2; clear; break;;
			[Nn]) stage1; clear;;
			[Qq]) exit;;
		esac
done


clear
echo
echo "You are going to transfer $source_user's data to $target_user's home folder, located at $tgt

You can enter Y to continue, N to start over, or Q to exit"
while true; do
	read -p "Ready to transfer?" -n 1 yn
		case $yn in
			[Yy]) break;;
			[Nn]) stage1; clear; stage2; clear;;
			[Qq]) exit;;
		esac
done


# Bulk data transfer from default home folders
sudo rsync -avr --progress "$src/Destkop" "$src/Documents" "$src/Downloads" "$src/Movies" "$src/Music" "$src/Pictures" "$tgt/"

# Delete new application dependencies
sudo rm -rf "$tgt/Library/Safari" "$tgt/Library/Calendars" "$tgt/Library/Mail" "$tgt/Library/Application\ Support/AddressBook"

# Rebuild old application dependencies
sudo rsync -avr --progress "$src/Library/Safari" "$src/Library/Calendars" "$src/Library/Mail" "$tgt/Library/" && sudo rsync -avr --progress "$src/Library/Application\ Support/AddressBook" "$tgt/Library/Application\ Support/AddressBook"
