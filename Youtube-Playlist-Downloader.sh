#!/bin/bash
#Nicolas Julian
#Playlist youtube to mp3 
#18 January 2019

#Color
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
PUR='\033[0;35m'
GRN="\e[32m"
WHI="\e[37m"
NC='\033[0m'
RESET='\e[0m'

#Clear screen
clear

# Check if youtube-dl and python already exists
# then install if it didn't
if [[ -f /usr/local/bin/youtube-dl ]] ; then
	echo -e ""$WHI"Youtube-dl already installed, press any key to continue $RESET"
	read answer
else
	echo -e ""$WHI"Youtube-dl is not installed , press any key to install $RESET"
	read answer
		#Install Python2.7
			sudo apt install -y python2.7
		#Install youtube-dl
			sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
			sudo chmod a+rx /usr/local/bin/youtube-dl
		#Install Converter Media
			sudo apt-get install -y ffmpeg

fi

proses(){
#Choice
cat <<EOF
          [+] Youtube Playlist Downloader [+]
       
---------------------------------------------------
   1.Only One Playlist
   2.Download More than one playlist
                
                by:https://github.com/nicolasjulian
---------------------------------------------------

EOF

read -p "1 Playlist or More than one ?(1/2) :  " choicetool

download_request(){   	
#Sending request to update and download		
	echo "Update to latest youtube-dl"
	sudo youtube-dl -U
	youtube-dl -i --extract-audio --audio-format mp3 -o "$2/%(title)s.%(ext)s" "$1"
	}
#Check which one tools choice
if [[ $choicetool == 1 ]]; then
	#User input url singel
	while read -p 'Insert Playlist Url : ' masukurl && [[ -z "$masukurl" ]] ; do
  		echo -e ""$ORANGE"https://www.youtube.com/playlist?list=(playlistid) $RESET"
	done
else
	#User input url multiple
	ls *.txt
	while read -p 'Insert Playlist Url File : ' urlfile && [[ ! -f "$urlfile" ]] ; do
  		echo -e ""$RED" File Not Found $RESET"
	done
fi
	#Check if folder aldready exists 
	#then create if didn't
		if [[ $folderFile == '' ]]; then
  		read -p "Enter target folder: " folderFile
			 if [[ ! -d "$folderFile" ]]; then
    			echo "Creating $folderFile/ folder"
    			mkdir $folderFile
  			else
				echo  "File Already Exist Now Start Downloading"
    		 fi
    	fi

   #Following up choice
	if [[ $choicetool == 1 ]]; then
   		download_request "$masukurl" "$folderFile"
   
	else
		IFS=$'\r\n' GLOBIGNORE='*' command eval  'semuaurl=($(cat $urlfile))'
		con=1

			for (( i = 0; i < "${#semuaurl[@]}"; i++ )); do
		  		list="${semuaurl[$i]}"
		  		file=$folderFile
		  		indexer=$((con++))

		  		download_request "$list" "$file" "indexer"
		   	done
   fi

}

#Loop to user input again
while true ; do
	proses
	read -p "Do You Want to Download Another Again ?(y/n) :" agik
	if [[ $agik == n ]]; then
		exit
	fi
done
