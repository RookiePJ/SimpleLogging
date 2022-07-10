#!/bin/bash

# A very simple example bash script to show the useage of simple logging untility (loggingUtility.bash)

#set the name of the log file - typically the name of the shell script 
ERROR_LOG=${0}.log       # example.bash.log in the script directory

#import the script from the script source directory
SOURCE_DIR=$(pwd)
source /${SOURCE_DIR}/loggingUtility.bash

# Show how to generate some logs....

#Info
LogInfo "Information Message 1" "Information Message 2" "Information Message 3" "Information Message 4"

#Warn
LogWarn "Warning Message 1" "Warning Message 2" "Warning Message 3" "Warning Message 4"

#Error
LogError "Error Message 1" "Error Message 2" "Error Message 3" "Error Message 4"

#End Of File
