
#! /bin/bash

# Use colors in terminal messages: https://notesontech.com/bash-text-formatting/
### Text formatting ###

CLEAR="\x1B[0m"

# Text settings.
BOLD="\x1B[1m"

# Text color.
RED="\x1B[31m"
GREEN="\x1B[32m"
YELLOW="\x1B[33m"

# Background color with bold font.
RED_BG_BOLD="\x1B[1;41m"
GREEN_BG_BOLD="\x1B[1;42m"

### End of text formatting ###

### Work with flags ###
while getopts ":f:" option; do
  case $option in
    f)
      FILE_NAME="$OPTARG"
      ;;
    *)
      echo "Usage: $0 [-f FILE_NAME]"
      exit 1
      ;;
  esac
done

PROJECT=$(git rev-parse --show-toplevel)
OUTPUT_DIRECTORY=$PROJECT/source/examples/generated/react-native/v12
INPUT_FILE=$(find $PROJECT/examples/react-native/v12/TestApp -type f -print | grep -i $FILE_NAME)

if [[ -n $INPUT_FILE ]]
then
# standard bluehawking
rm -f $OUTPUT_DIRECTORY/*
echo "${GREEN_BG_BOLD} Bluehawk: ${CLEAR} ${GREEN}Generate samples from '$FILE_NAME' ${CLEAR}"
bluehawk snip $INPUT_FILE -o $OUTPUT_DIRECTORY --format=rst

FILES_TO_REMOVE=$(find $OUTPUT_DIRECTORY -type f -not -name "*.rst")

echo "
${YELLOW}Removing:${CLEAR}
$FILES_TO_REMOVE"
echo "
${YELLOW}From:${CLEAR} $OUTPUT_DIRECTORY"

# Delete non-.rst files in output directory.
find $OUTPUT_DIRECTORY -type f -not -name "*.rst" -delete
echo "
Non-.rst files removed."

echo "
${GREEN_BG_BOLD} Bluehawk: ${CLEAR} Complete!"
else
echo -e "${RED_BG_BOLD} Couldn't find '${FILE_NAME}'."
fi
