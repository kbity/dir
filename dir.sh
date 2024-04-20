#!/bin/bash

# Function to simulate the dir command
dir_command() {
    local directory
    if [ $# -gt 0 ]; then
        directory="$1"
    else
        directory="$(pwd)"
    fi
    
    # Arrays to store directories and files
    declare -a dirs
    declare -a files
    total_file_size=0
    
    # Iterate over all entries in the specified directory
    for entry in "$directory"/*; do
        if [ -d "$entry" ]; then
            # If it's a directory, add it to the directories array
            dirs+=("$entry")
        else
            # Otherwise, add it to the files array
            files+=("$entry")
            size=$(stat -c %s -- "$entry") # Corrected line to get file size
            ((total_file_size += size))
        fi
    done
    
    # Display directories followed by files
    for dir in "${dirs[@]}"; do
        mod_time=$(stat -c %y -- "$dir" | cut -d '.' -f1)
        # Extracting directory name
        name=$(basename "$dir")
        printf "%-22s %-14s  %s\n" "$mod_time" "<DIR>" "$name"
    done
    for file in "${files[@]}"; do
        size=$(stat -c %s -- "$file")
        mod_time=$(stat -c %y -- "$file" | cut -d '.' -f1)
        # Get file details
        file_info=$(ls -ld -- "$file")
        # Extracting file/directory name
        name=$(basename "$file")
        # Formatting output according to the provided format
        printf "%-22s %14s  %-s\n" "$mod_time" "$size" "$name"
    done
    # Display the total size of all files and the drive's free space
    num_dirs=${#dirs[@]}
    num_files=${#files[@]}
    # Display the number of files and directories
    printf "%15s File(s) %19s bytes\n" "$num_files" "$total_file_size"
    printf "%15s Dir(s) %20s bytes free\n\n" "$num_dirs" "$(df -B1 -P "$directory" | awk 'NR==2 {print $4}')"
}

# Main script
if [ "$#" -eq 0 ]; then
    # No arguments provided, list files in current directory
    volume_label=$(blkid -s LABEL "$(df -P . | awk 'NR==2 {print $1}' | sed 's/://')")
    drive=$(df -P . | awk 'NR==2 {print $6}')
    if [ -z "$volume_label" ]; then
        echo " Volume in drive $drive has no label."
    else
        echo " Volume in drive $drive is $volume_label"
    fi
    echo " Volume Serial Number is $(lsblk -no UUID $(df -P . | awk 'NR==2 {print $1}'))"
    echo
    echo " Directory of $(pwd)"
    echo
    dir_command "$(pwd)"
else
    for directory in "$@"; do
        if [ -d "$directory" ]; then
            volume_label=$(lsblk -no LABEL "$(df -P "$directory" | awk 'NR==2 {print $1}')")
            drive=$(df -P "$directory" | awk 'NR==2 {print $6}')
            if [ -z "$volume_label" ]; then
                echo " Volume in drive $drive has no label."
            else
                echo " Volume in drive $drive is $volume_label"
            fi
            echo " Volume Serial Number is $(lsblk -no UUID $(df -P "$directory" | awk 'NR==2 {print $1}'))"
            echo
            echo " Directory of $directory"
            echo
            dir_command "$directory"
        else
            # If the argument is a file, display its details
            if [ -e "$directory" ]; then
                ls -ld -- "$directory"
            else
                echo "dir: cannot access '$directory': No such file or directory"
            fi
        fi
    done
fi
