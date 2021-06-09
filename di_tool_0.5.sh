#!/bin/bash


clear
echo
echo "di_tool 0.5 -- by Rich Wright"
echo
echo "run me as root or you will be prompted to enter your password"
echo




# user selects their source volume and source home folder

function SOURCE {

	# source volume assigned
	
	echo
	echo "Where is the data currently located?"
	echo
	
	cd /Volumes/
	
	PS3='Select a source volume: '
	
	select sourceVolume in *;
	
		do
		
			case $sourceVolume in
			
				*)		
				
					clear ;
					
					echo ;
					
					echo "You picked " $sourceVolume ;
					echo;
					
					break ;;
					
			esac
			
		done





	# source home folder assigned
	echo
	echo "Which user's data is being transferred?"
	echo
	
	cd "/Volumes/$sourceVolume/Users/"
	
	PS3='Select a source folder: '
	
	select sourceUser in *;
	
		do
		
			case $sourceUser in
			
				*)		
				
					clear ;
					
					echo ;
					
					echo "You picked " $sourceUser ;
					
					echo ;
					
					break ;;
					
			esac
			
		done
		
		
	
	
	# final path to the source home folder, assigned to variable
	
	src=$(
		echo -n "/Volumes/$source_vol/Users/$source_user"
		)

}



# user selects their destination volume and destination folder

function DESTINATION {

	# target volume assigned
	echo
	echo "Where are you transferring this data to?"
	echo

	cd /Volumes/

	PS3='Select a destination volume: '

	select destVolume in *;

		do
	
			case $destVolume in
		
				*)
			
					clear ;
				
					echo ;
				
					echo "You picked " $destVolume ;
				
					echo ;
				
					break ;;

			esac

		done





	# target home folder assigned
	echo
	echo "Which user is going to recieve this data?"
	echo

	cd "/Volumes/$target_vol/Users/"

	PS3='Select a destination folder: '

	select destnUser in *;

		do
	
			case $desUser in
		
				*)
			
					clear ;
				
					echo ;
				
					echo "You picked " $destUser ;
				
					echo ;
				
					break ;;

			esac
		
		done
	
	
	# final path to the destination home folder
	dest=$(
		echo -n "/Volumes/$target_vol/Users/$target_user"
		)


}




# contains two(2) prompts that validate the user's input
# gives the user a chance to start over in case of mistake at either selection stage

function INPUTVALIDATION {

	clear
	echo
	echo "You are going to transfer $sourceUser's data"
	echo
	echo "You can enter Y to continue, N to start over, or Q to quit"

	while true; do

		read -p "Continue?" -n 1 yn
	
			case $yn in
		
				[Yy])
				
					DESTINATION ;
				
					clear;
				
					break;;
			
				[Nn])
				
					SOURCE ;
				
					clear ;;
			
				[Qq])
			
					exit ;;
				
			esac
		
	done


	clear
	echo
	echo "You are going to transfer $sourceUser's data to $destUser's home folder, located at $dest"
	echo
	echo "You can enter Y to continue, N to start over, or Q to exit"

	while true; do

		read -p "Ready to transfer?" -n 1 yn
	
			case $yn in
		
				[Yy])
			
					break;;
			
				[Nn])
			
					SOURCE ;
				
					clear ;
				
					DESTINATION ;
				
					clear ;;
				
				[Qq])
			
					exit ;;
				
			esac
		
	done

}



# the core functionality of the program, contains instructions for transferring the data
# rsync is not scripted here to with the inclusion of 'sudo'
# it may fail if the script itself is not run with 'sudo'

function DATATRANSFER {

	# Bulk data transfer from default home folders
	rsync -avr --progress "$src/Destkop" "$src/Documents" "$src/Downloads" "$src/Movies" "$src/Music" "$src/Pictures" "$dest/"


	# Delete new application dependencies
	rm -rf "$dest/Library/Safari" "$dest/Library/Calendars" "$dest/Library/Mail" "$dest/Library/Application\ Support/AddressBook"


	# Rebuild old application dependencies
	rsync -avrz "$src/Library/Application\ Support/AddressBook" "$tgt/Library/Application\ Support/" &

	rsync -avr --progress "$src/Library/Safari" "$src/Library/Calendars" "$src/Library/Mail" "$tgt/Library/"

}