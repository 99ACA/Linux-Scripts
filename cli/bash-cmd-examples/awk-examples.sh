
# result <original-line> <user_[idx]@domain.com>
awk '{print $s " " "user_" NR-1 "@domain.com" }' email.txt > edit-file.txt
