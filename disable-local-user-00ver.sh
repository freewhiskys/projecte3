#!/bin/bash
#https://github.com/freewhiskys/projecte3

function usage() {
cat <<EOF	
	Usage: ${0} [-draz] USER [USERN] 
	Disable a local Linux account. 
	-d Deletes accounts instead of disabling them. 
	-r Removes the home directory associated with the account(s). 
	-a Creates an archive of the home directory associated with the account(s).
	-z Disables a user but does not delete.
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

while getopts ":d:r:a:z:" OPT
do
  case ${OPTº} in
    d)
      USER="${OPTARG}"
      userdel ${USER}
      if [ $? -eq 0 ]; then
        echo "Se ha eliminado el usuario: ${USER}"
      else
		echo "No se ha podido eliminar el usuario"
      fi
      ;;
      
    r)
 	USER="${OPTARG}"
      	rm -r /home/${USER}
      	if [ $? -eq 0 ]; then
        	echo "Se ha eliminado el Home del usuario: ${USER} "
      	else
		echo "No se ha podido eliminar el Home del usuario"
      	fi
      	;;
      
    a)
    	USER="${OPTARG}"
	cp -r /home/${USER} /home/ausias/${USER}.cs
	if [ $? -eq 0 ]; then
        	echo "La copia de seguridad realizada con exito al usuario: ${USER}"
      	else
		echo "No se ha podido realizar la copia de seguridad"
      	fi
      	;;
      
    z)
    	USER="${OPTARG}"
      	usermod -L ${USER}
      	if [ $? -eq 0 ]; then
        	echo "Ha sido deshabilitado el usuario: ${USER} "
      	else
		echo "No se ha podido deshabilitar el usuario"
      	fi
      	;;
      
    \?)
	echo "ERROR: Invalid option -$OPTARG"
	usage
	;;
    :)
	echo "ERROR: -$OPTARG requires an argument."
	;;
    *)
	echo "Unknown error."
	usage
	;;
  esac
done

shift "$(( OPTIND - 1 ))"

if [ -z "${USER}" ]; then
	usage
fi

