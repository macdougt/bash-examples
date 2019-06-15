#!/usr/bin/env bash

# Check remote file
REMOTE_FILE=$1

if curl --output /dev/null --silent --head --fail "$REMOTE_FILE"; then
  echo "Remote file exists: $REMOTE_FILE"

  # Get the base name of the file
  FILE=$(basename $REMOTE_FILE)
  echo $FILE

  # Make a quick back up of the file
  if test -f "$FILE"; then
    BACKUP_FILE=$(/usr/local/bin/bu $FILE)
    echo "$FILE exists, making a back up: $BACKUP_FILE"
  else
    echo "No file to replace"
    exit 1
  fi

  curl -s -O $REMOTE_FILE
  /Applications/DiffMerge.app/Contents/Resources/diffmerge.sh $FILE $BACKUP_FILE
  
  # Remove backup file 
  /usr/local/bin/trash $BACKUP_FILE

else
  echo "Remote file does not exist: $REMOTE_FILE"
fi
