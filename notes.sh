#!/bin/bash

{
	FILENAME=".NOTES"
	NOTESDIR=$(git rev-parse --show-toplevel)
	BRANCH=$(git rev-parse --abbrev-ref HEAD)
} 2>/dev/null

# are we in a git repo. if not, use the global notes file in home dir
if [ $? -ne 0 ]; then
	NOTESDIR=$HOME
	BRANCH="-"
fi

NOTESFILE="$NOTESDIR/$FILENAME"

if ! (($#)); then
	# no arguments, print file
	cat "$NOTESFILE"
elif [[ "$1" == "-c" ]]; then
	# clear file
	rm "$NOTESFILE"
elif [[ "$1" == "-e" ]]; then
	# test if already exluded
	grep -q '^.NOTES' "$NOTESDIR/.git/info/exclude"
	if [ $? -ne 0 ]; then
		# git exclude file in local repo
		echo .NOTES >> "$NOTESDIR/.git/info/exclude"
		echo "note-file excluded from git"
	else
		echo "note-file already excluded or this is not a git repo"
	fi
elif [[ "$1" == "-h" ]]; then
	# show notes info and help
	echo "notes-file: $NOTESFILE"
	echo "git-branch: $BRANCH"
	echo "Usage: notes.sh [-c] [-h] [note]"
	echo -e "\twith no arguments it will print all notes"
	echo -e "-c\tclear, delete all notes in this file"
	echo -e "-e\texclude notes-file from git"
	echo -e "-h\thelp, this message"
else
	# add all arguments to file prefixed with the date.
	printf "%s %s | %s\n" $(date +'%F') "$BRANCH" "$*" >> "$NOTESFILE"
fi
