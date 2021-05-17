# meaning searches in $PATH for bash
#!/usr/bin/env bash

FILE_NAME=$1

# absolute file path
ABSOLUTE_FILE_PATH=$(realpath $FILE_NAME)


printf "Looking for uniq emails: " && while true; do printf "." && sleep 5; done 2>/dev/null &

EMAIL_LIST=(`grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" $ABSOLUTE_FILE_PATH | sed -e 's/^[[:space:]]*//' | grep -v example | awk '{ print length($0) " " $0; }' | sort -r -n | cut -d ' ' -f 2- | uniq`)

# Close the search bg
for job in `jobs -p`
do
    printf "(total amount of emails:${#EMAIL_LIST[@]})\n"
    (kill -9 $job)  &>/dev/null; # redirect stdout stderr
done 2>/dev/null # redirect stdout stderr

# Wait background  print process to be closed
wait 2>/dev/null # redirect stdout stderr

SED_CONCAT_CMD=""
SED_CMD_BULK_SIZE=250

printf "Start replace emails (amount of emails ${#EMAIL_LIST[@]}, each dot represent replacement of $SED_CMD_BULK_SIZE emails): "


for IDX in "${!EMAIL_LIST[@]}"
do    
    EMAIL="${EMAIL_LIST[IDX]}"
    # Concatenation the sed cmd -> s/{old}/{new}/g
    SED_CONCAT_CMD+="s/$EMAIL/user_$IDX@gen.it/g;"

    # Bulk update or last chunck
    if [[ $(($IDX+1)) -eq ${#EMAIL_LIST[@]} ]] || [[ $(($IDX%$SED_CMD_BULK_SIZE)) -eq 0 ]]; then
        sed -i $SED_CONCAT_CMD $ABSOLUTE_FILE_PATH
        SED_CONCAT_CMD=""
    fi
    # Print progress
    (mod=$(( $IDX%(( $SED_CMD_BULK_SIZE*10 )) )) && [[ mod -eq 0 ]] && [[ $IDX -ne 0 ]] && printf "[$IDX/${#EMAIL_LIST[@]}]") || \
    (mod=$(( $IDX%$SED_CMD_BULK_SIZE )) && [[ mod -eq 0 ]] && [[ $IDX -ne 0 ]] && printf ".")  # for each mail replace print dot
done

wait 