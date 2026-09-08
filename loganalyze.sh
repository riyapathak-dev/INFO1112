#!/bin/bash
if [ "$#" -eq 0 ] 
then 
    argument_dir=$(pwd)
elif [ "$#" -eq 1 ]
then 
    if [ -d "$1" ]
    then
    argument_dir=$1
    else 
    echo -e "usage: arg needs to be a directory.\n"
    exit 1
    fi
else
    echo -e "usage: more than 1 arg is not allowed.\n"
    exit 2 
fi
total_count=0
max_count=0
file_max=""
>"$HOME/summary.log"
>"$HOME/analysisData.log"

log_files=$(find "$argument_dir" -maxdepth 1 -type f \( -name "*.log" -o -name "syslog" \) -mtime -7 ! -name "analysisData.log" ! -name "summary.log") #excluded these files because when I ran it without arguments, it modified the output files.
if [ -z "$log_files" ]
then 
    echo -e "No.of modified log files: 0\n"
    exit 0
fi
for file in $log_files
do 
    count=$(grep -i "error" "$file"| wc -l)
    total_count=$((total_count+count))
    echo "File name: $file, Errors: $count." | tee -a "$HOME/analysisData.log"
    echo "*********************************" | tee -a "$HOME/analysisData.log"
    if [ "$count" -gt "$max_count" ]
    then 
    max_count="$count"
    file_max="$file"
    fi 
done 

echo "Total errors found: $total_count" | tee -a "$HOME/summary.log"
echo "File with max errors: $(basename $file_max), number of errors: $max_count" | tee -a "$HOME/summary.log"









