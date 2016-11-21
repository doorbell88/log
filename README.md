# Log
A bash script for adding timestamped entries to a running log text document

    usage: log [[[-f file ] [-i]] | [-h]]
    
    -f | --file             Allows you to specify a log file when running the script
    
    -i | --interactive      Interactice format lists available log files and prompts user for log file
    
    -h | --help             Displays usage syntax


NOTES:

- Script is currently written to be useful within my own folders on my computer.  My log files folder (and therefore the default $LOG_FOLDER in the script) is in ~/Desktop/Programming/Scripting/Logs

- When writing the body of the log entry, the script reads from $(cat).  Therefore, once the user has pressed enter, the line cannot be edited.  (For some users it may be more user-friendly to simply run TextEdit or another text editor, but for the purposesof this script it does not.)
