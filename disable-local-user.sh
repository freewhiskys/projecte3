#! /bin/bash

# Display the usage and exit.

function usage () {
   cat <<EOF
Usage: nomscript [-u usuari] [-h hostname] [-t]
   -u   usuari de la base de dades (obligatori)
   -h   hostname on es connectarà (obligatori
   -p   port (no obligatori ja que per defecte és 3306, però si existeix ha de ser un numero superior a 1024 i inferior o igual a 65535)
   -t   no es connecta,  només comprova connexió
EOF
}

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
 then
  echo 'You are not root.'
  exit
fi


# Parse the options.
# Remove the options while leaving the remaining arguments.
# If the user doesn't supply at least one argument, give them help.
# Loop through all the usernames supplied as arguments.
# Make sure the UID of the account is at least 1000.
# Create an archive if requested to do so.
# Make sure the ARCHIVE_DIR directory exists.
# Archive the user's home directory and move it into the ARCHIVE_DIR
# Delete the user.
# Check to see if the userdel command succeeded.
# We don't want to tell the user that an account was deleted when it hasn't been.
# Check to see if the chage command succeeded.
# We don't want to tell the user that an account was disabled when it hasn't been.
