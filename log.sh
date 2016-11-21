#!/bin/bash

# A program to add log entries with date and time stamps, etc.




##### CONSTANTS	#####

RIGHT_NOW_DATE=$(date +"%m-%d-%Y")
# RIGHT_NOW_TIME=$(date +"%H:%M %p") #24-hour format
RIGHT_NOW_TIME=$(date +"%I:%M %p") #12-hour format
TIME_STAMP="Updated on $RIGHT_NOW_DATE at $RIGHT_NOW_TIME by $USER"
LOG_FOLDER=~/Desktop/Programming/Scripting/Logs
LOG=

# Log editable contents
title=
logger_name=
# body=

# Text formatting
log_list_color=130		#brown
typing_color=7			#white
warning_color=1			#red

# Cursor position parameters
body_row=10






##### FUNCTIONS #####


# CLEANUP FUNCTION
clean_up() {
	clear
	tput sgr0		#return text to normal
	exit 1
	# tput rc		#return cursor position
}

exit_prompt() {
	# kill -SIGTERM	# [ctrl+D] to save the cat for $body 
	# clear
	# echo $body

	tput cub 2		# Move cursor back 2 spaces (to get rid of "^C" output)
	tput setaf $warning_color
	echo -en "  \nAre you sure you want to exit without saving entry? (y/n)  >  "
	read exit_wo_save
	tput sgr0

	if [ "$exit_wo_save" = "y" ]; then
		clean_up
	else
		clear
		tput sgr0

		# body=$body
		get_body
		# continue
	fi
}




# SETUP FUNCTIONS

#usage syntax
usage() {
	echo
	echo "usage: log [[[-f file ] [-i]] | [-h]]"
	echo
}

# get the title of an existing log
get_log_title() {
	# Read the first line of the log file
	LOG=$(less $filename | head -n 2)
	if [ -n "$LOG" ]; then
		continue

	# If a log file exists, but is empty, let's give it a title
	else
		echo -n "What will you title this log?  >  "
		read LOG
		echo -e "$LOG\n\n" > $filename
	fi
}

# create a title for a new log
new_log_title() {
	if [ -f $filename ]; then
		# continue
		get_log_title
	else
		touch $filename		#create log in specified filename
		# Now let's give it a title
		echo -n "What will you title this log?  >  "
		read LOG
		echo -e "$LOG\n\n" > $filename
	fi
}

# show list of existing logs
log_list() {
	# cd $LOG_FOLDER
	tput setaf $log_list_color	# Yellow text

	tput smul		# Underline
	echo -e "\nList of log files:\n"
	tput rmul		# (End underline)

	# List all the files in LOG_FOLDER
	echo -e * | tr " " "\n"
	tput sgr0		# back to normal text
}




# WRITING INTO THE LOG
get_title() {

	clear
	echo "NEW LOG ENTRY FOR:"
	echo -e "$LOG\n"
	preview_page
	tput cup 4 16	# Move cursor to "TITLE: "

	tput setaf $typing_color
	read title
	tput sgr0
}

# get logger name
get_logger_name() {

	clear
	echo "NEW LOG ENTRY FOR:"
	echo -e "$LOG\n"
	preview_page
	tput cup 5 16	# Move cursor to "LOGGED BY: "

	tput setaf $typing_color
	read logger_name
	tput sgr0
}

# get relative time (just now, 5 minutes ago, etc.)
get_relative_time() {
	# Temporary function stub
	echo "function relative_time"
}

# get body
get_body() {

	clear
	echo "NEW LOG ENTRY FOR:"
	echo -e "$LOG\n"
	preview_page
	# tput cup $body_row 0	# Move cursor to body editing

	tput setaf $typing_color
	body=$body$(cat)

	tput sgr0
}




# FORMATTING THE LOG ENTRY

#previews log entry with colored text
preview_page() {

	cat <<- _EOF_
	==============================================================
	TITLE:		$(tput setaf $typing_color)$title$(tput sgr0)
	LOGGED BY:	$(tput setaf $typing_color)$logger_name$(tput sgr0)
	-------------------------------
	LOG DATE:	$RIGHT_NOW_DATE
	LOG TIME:	$RIGHT_NOW_TIME
	-------------------------------
	$(tput setaf $typing_color)$(tput cub1)$body$(tput sgr0)
	_EOF_
}

#raw text log entry (no color) for writing to log document
write_page() {

	cat <<- _EOF_
	==============================================================
	TITLE:		$title
	LOGGED BY:	$logger_name
	-------------------------------
	LOG DATE:	$RIGHT_NOW_DATE
	LOG TIME:	$RIGHT_NOW_TIME
	-------------------------------
	$body




	_EOF_
}








##### MAIN #####

# clean up if terminated with ctrl+D
trap clean_up SIGTERM
# prompt to save if terminated with ctrl+C
trap exit_prompt SIGINT


# move to directory with log files
cd $LOG_FOLDER


interactive=0
filename=$LOG_FOLDER/log.txt
# filename=~/Desktop/Programming/Scripting/Logs/log.txt

while [ "$1" != "" ]; do
	case $1 in
		-f | --file )			shift
								filename=$1		#use filename specified after -f
								new_log_title
								;;

		-i | --interactive )	interactive=1
								log_list
								;;

		-h | --help )			usage
								exit
								;;

		* )						usage
								exit
	esac
	shift
done


# Add interactive mode
if [ $interactive = 1 ]; then
	response=

	# if user presses enter, default filename is used
	echo -e "\nEnter name of log file"
	echo -e "(DEFAULT: [$filename])\n"
	tput setaf $log_list_color
	echo -n "  >>  "
	read response
	tput sgr0

	if [ -n "$response" ]; then

		# Log file already exits -- add to log?
		if [ -f $response ]; then
			echo -en "\nLog already exists.  Add to log? (y/n)  >  "
			read add
			if [ "$add" = "y" ]; then
				filename=$response	# add log entry to the filename specified
				# get_log_title		# get existing log title
			else
				echo "exiting program"
				exit 1
			fi

		# Does not yet exist -- create and begin log?
		else
			echo -n "Output file does not exist.  Create file? (y/n)  >  "
			read create

			if [ "$create" = "y" ]; then
				filename=$response
				touch $filename		#create log in specified filename
				echo -n "What will you title this log?  >  "
				read LOG
				echo -e "$LOG\n\n" > $filename
			else
				echo "exiting program"
				exit 1
			fi
		fi
	fi
fi



get_log_title	# get existing log title
clear			# clear screen to start log entry interface


get_title 				# move cursor to title position, and record typing
get_logger_name			# move cursor to name position, and record typing
# get_relative_time		# (if event happened in past, record when)
get_body				# move cursor to body position, and record typing


# Append new log entry to log file
write_page >> $filename

# Give user a message saying it was successfully appended
tput setaf $log_list_color	
echo    "........................................................"
echo -e "Event successfully logged to $filename\n"
tput sgr0

exit 0
# clean_up

