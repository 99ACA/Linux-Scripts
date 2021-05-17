
# sudo apt install uuid-runtime

# Change order 
sed 's/\ (..*\)@\(..*\)\.\(..*\) /\2@\3.\1/'  email.txt 
sed 's/\(..[A-Za-z0-9._%+-]\+\)@\(..[A-Za-z0-9.-]\+\)\.\(..*\)/\2@\3.\1/'  email.txt
sed 's/\(..[A-Za-z0-9._%+-]\+\)@\(..[A-Za-z0-9.-]\+\)\.\(..[A-Za-z]\{2-6\}\)/\2@\3.\1/'  email.txt
sed  "s/\(..[A-Za-z0-9._%+-]\+\)@\(..*\)\.\(..[A-Za-z]\+\)/$(uuidgen)@general.\3/g"  email.txt