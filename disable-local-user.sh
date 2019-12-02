#!/bin/bash
#https://github.com/freewhiskys/projecte3
# Display the usage and exit.

function usage() {
cat <<EOF	
	Usage: ${0} [-d] USER 
	Usage: ${0} [-r] USER
	Usage: ${0} [-k] USER
	Usage: ${0} [-t] USER
	Usage: ${0} [-x] USER   
	
	Disable a local Linux account. 
	-d Deletes accounts instead of disabling them. 
	-r Removes the home directory associated with the account(s). 
	-k Deletes the account and removes the home directory associated with the account(s).
	-t Creates a tar file of the home directory associated with the account(s).
	-x Disables a user but does not delete.
EOF
exit 1
}

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
 	echo 'Please run with sudo or as root.'
   	exit 1
fi

if [ $# -eq 0 ]; then
	usage
fi

# Parse the options.

while getopts ":d:r:k:t:x:" OPT;
do
  case ${OPT} in
    d)
	  # Delete the user.
      USER=${OPTARG}
      userdel ${USER}
      # Check to see if the userdel command succeeded.
      # We don't want to tell the user that an account was deleted when it hasn't been.
      if [ $? -eq 0 ]; then
        echo "Se ha eliminado el usuario: ${USER}"
      else
		echo "No se ha podido eliminar el usuario"
      fi
      ;;
      
    r)
	  USER=${OPTARG}
      rm -r /home/${USER}
      if [ $? -eq 0 ]; then
		echo "Se ha eliminado el Home del usuario: ${USER} "
      else
		echo "No se ha podido eliminar el Home del usuario"
      fi
      ;;
     k)
      # Deletes the user.
      USER=${OPTARG}
      userdel -r  ${USER}
      # Check to see if the userdel command succeeded.
      # We don't want to tell the user that an account was deleted when it hasn't been.
      if [ $? -eq 0 ]; then
        echo "Se ha eliminado el usuario: ${USER} y se ha eliminado su respectivo HOME."
      else
		echo "No se ha podido eliminar el usuario y su HOME."
      fi
      ;;
      
    t)
      # Create an archive if requested to do so.
      # Archive the user's home directory and move it into the ARCHIVE_DIR
      USER=${OPTARG}
	  tar -cvf Archive_DIR_$USER.tar.gz /home/$USER
	  # Make sure the ARCHIVE_DIR directory exists.
	  if [ $? -eq 0 ]; then
      	echo "La copia del home del usuario ${USER} sido ha realizada."
      else
		echo "No se ha podido realizar la copia del home del usuario ${USER}"
      fi
      ;;
      
    x)
       USER=${OPTARG}
       usermod -L ${USER}
       # We don't want to tell the user that an account was disabled when it hasn't been.
       if [ $? -eq 0 ]; then
       	echo "El usuario ${USER} ha sido deshabilitado."
       else
		echo "No se ha podido deshabilitar el usuario ${USER}."
       fi
       ;;
      
    \?)
		echo "ERROR: Invalid option -$OPTARG"
		usage
		;;
    :)
		# If the user doesn't supply at least one argument, give them help. 
		echo "ERROR: -$OPTARG requires an argument."
		;;
    \?)
        echo "ERROR: Invalid option -$OPTARG"
        usage
        ;;
  esac
done
if [ -z "${USER}" ]; then
	usage
fi
