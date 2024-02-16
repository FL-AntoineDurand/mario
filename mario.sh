#!/bin/bash

grid="00222220000
02222222220
03331141000
31311141110
31331113111
33111133330
00111111100"

cols=$(echo "$grid" | head -n 1 | wc -c)

filename="output.txt"
rm -rf ./$filename ./.git
# Create an empty file
> "$filename"
# Set the date to July 9th, 2023, at 12:00 PM
# sudo date -s "2023-07-09 12:00:00"
git init
git config --local user.email "antoine.durand@fluid-lifecycle.com"
git config --local user.name "antoine"


reference_date="2023-07-09"

add_one_day() {
    reference_date=$(date -ud "$reference_date + 1 day")
}


doPixel() {
    local num_times=$1

    echo $num_times
        
    # Loop 'num_times' and append 'x' to the file each time
    for X in `seq 2 $num_times`
    do
        echo -n X
        echo "x" >> "$filename"
        git add "$filename"
        GIT_COMMITTER_DATE="${reference_date}" git commit -m "Added $num_times 'x' to $filename" --date "${reference_date}"
    done
    echo
    add_one_day
}





for ((i = 1; i <= cols; i++)); do
    for ((j = i; j <= ${#grid}; j += $cols)); do
        char="${grid:j-1:1}"
        if [[ "$char" =~ [0-9] ]]; then
            multiplied_char=$(( char * 5 ))
            printf "%d\t%s\n" "$multiplied_char" "$char"
            doPixel "$multiplied_char"
        else
            printf "%s\n" "$char"
        fi
    done
done
