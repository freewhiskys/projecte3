#! /bin/bash

# Display the usage and exit.

function usage () {
   cat <<EOF
Usage: ./disable-local-user [-u usuari] [-h hostname] [-t]
   -u   nom de l'usuari a afegir (obligatori)
   -i   id de l'usuario a afegir (obligatori)
   -t   fer un tar del home de l'usuari
EOF
}

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
   echo 'Please run with sudo or as root.' >&2
   exit 1
fi

# Parse the options.

while getopts ":u:i:p:t" o; do
    case "${o}" in
        u)
            USER=${OPTARG}
            ;;
        i)  
			# Make sure the UID of the account is at least 1000.
            if [[ ${OPTARG} -le "1000" ]];
			then
				usage
			else
				ID=${OPTARG}
			fi
            ;;
        p)  
			
			if [[ ${OPTARG} -le "1024" || ${OPTARG} -ge "65535" ]];
			then
				usage
			else
				port=${OPTARG}
			fi
            ;;
		
		t) 	
			# Create an archive if requested to do so.
			# Archive the user's home directory and move it into the ARCHIVE_DIR
			tar -cvf Archive_DIR_$USER.tar /home/$USER
			
			# Make sure the ARCHIVE_DIR directory exists.
			ls $HOME/Archive_DIR_$USER.tar
			;;
        :)  
            # If the user doesn't supply at least one argument, give them help. 
            echo "ERROR: Option -$OPTARG requires an argument"
            #usage
            ;;
        \?)
            echo "ERROR: Invalid option -$OPTARG"
            #usage
            ;;
    esac
done

# Remove the options while leaving the remaining arguments.

# Loop through all the usernames supplied as arguments.






# Delete the user.

userdel -r ${USER}

# Check to see if the userdel command succeeded.
if [[ "${?}" -ne 0 ]]
then
  echo "The account ${USER} was NOT deleted."
  exit 1
else
  echo "The account {$USER} was deleted"
fi
# We don't want to tell the user that an account was deleted when it hasn't been.
# Check to see if the chage command succeeded.
# We don't want to tell the user that an account was disabled when it hasn't been.
