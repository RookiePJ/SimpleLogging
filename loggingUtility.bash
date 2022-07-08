#!/bin/bash

# Simple logging, a very simple logging tool to produce timestamped logs
#------------------------------------------------------------------------------------------------
#Usage - set the file and directory

# Set the output file
#  ERROR_LOG=${0}.log   - to use the name of the script (ie $0) with the .log postfix

# Import into script
#  source /${SOURCE_DIR}/loggingUtility.bash

# To write to the log file

# To log an info message
#  LogInfo "Information" "Script called"

# To log a warning message passing strings
#  LogWarn "Invalid_Arguments" "Script called with invalid number of arguments" $someShellVariable

# To log an error message
#  LogError "Server_Failed_To_Stop" "Server has failed to stop " $1 $someShellVariable $yetAnotherShellVariable


#------------------------------------------------------------------------------------------------
# Change List
# Who          |When      |Why was this done                            | What was done
# P Rooke      |Oct 18    |Created - provide monitoring logs for splunk | Created specification and Error,Warn,Info functions.
# P Rooke      |Oct 18    |Added hostname for splunk                    | Each log entry will now include the hostname
# P Rooke      |Oct 18    |Splunk seems to work with key value pairs    | Logs now create key value pairs so splunk will use these as values
# P Rooke      |Nov 18    |Only log for scheduled servers               | checkAgentScheduledServer created - extra if statements
# P Rooke      |Nov 18    |For Splunk remove date from logfile name     | Now log to one file (with no date in filename) - roll over logs each day.
# P Rooke      |Nov 18    |Log for all servers                          | findServerType now returns type of server for splunk logs, removed checkAgentScheduledServer
# P Rooke      |Nov 18    |Log the type of server                       | log entries now record <SEVER_TYPE_SCHEDULE> and <SERVER_TYPE>
# P Rooke      |Jun 23    |Make script uploadable to github             | remove any reference to the company, project, and tool that script was developed for
# P Rooke      |Jun 23    |Server type was a project requirement        | remove any reference server type, not needed.
# P Rooke      |Jul 07    |Script not working in MacOS                  | modified date commands to work with the date formats for MacOS
# P Rooke      |Jul 07    |With no error file created was rolling over  | creates the new file if ERROR_LOG does not exists
#------------------------------------------------------------------------------------------------

#Function to Log Errors, Warnings or Information into a file defined in ERROR_LOG
#logs are created with date/time entries and the text passed in argument $1, $2, $3 and $4
#
#  LOG_LINE ::= <DATE> <TIME> <HOSTNAME > <SCRIPT_NAME> <LOG_LEVEL> <LOG_MESSAGE> <LOG_MESSAGE_2> <LOG_MESSAGE_3> <LOG_MESSAGE_4>
#  (args)       <--- $NOW --> <$HOSTNAME> <---$0------> <function-> <----$1-----> <----$2-------> <----$3-------> <----$4------->
#
#        LOG_LINE ::= <DATE> <TIME> <HOSTNAME> <SCRIPT_NAME> <LOG_LEVEL> <LOG_MESSAGE> <LOG_MESSAGE_2> <LOG_MESSAGE_3> <LOG_MESSAGE_4>
#
#        <DATE>          ::= <YYYY-MM-DD>
#        <TIME>          ::= <HH:MM>
#        <HOSTNAME>      ::= System name given by uname -n
#        <SCRIPT_NAME>   ::= Script name taken from $0 variable
#        <LOG_LEVEL>     ::= <ERROR> | <WARN> | <INFO>
#        <LOG_MESSAGE>   ::= Argument $1
#        <LOG_MESSAGE_2> ::= Argument $2
#        <LOG_MESSAGE_3> ::= Argument $3
#        <LOG_MESSAGE_4> ::= Argument $4
#

#Script starts here.

TRUE=0
FALSE=1

HOSTNAME=$(uname -n)

#roll over logs if this is a new day
rollOverLogs() {
    #YESTERDAY=$(date '+%Y-%m-%d' --date="yesterday")    - works for red hat linux
    YESTERDAY=$(date -v -1d '+%Y-%m-%d')    # MacOs linux (BSD)
    echo "Log file rolled over at the end of ${YESTERDAY}" >> $ERROR_LOG
    mv $ERROR_LOG $ERROR_LOG-${YESTERDAY}
    tar czvf $ERROR_LOG-${YESTERDAY}-tar.gz $ERROR_LOG-${YESTERDAY}
    echo "Log file rolled over, previous log file is to be found in ${ERROR_LOG}-${YESTERDAY} and archived in $ERROR_LOG-${YESTERDAY}-tar.gz" >> $ERROR_LOG
}


#check if this is a new day - if it is then roll over the logs.
checkForNewDay() {
  FILE_DAY=$(date '+%Y-%m-%d' -r ${ERROR_LOG} ); TODAY=$(date '+%Y-%m-%d')  - works on red hat

  #[ ! -f $ERROR_LOG ] && { echo >> $ERROR_LOG; }     # if ERROR_LOG file does not exist then create it
  FILE_DAY=$(date -r ${ERROR_LOG} | cut -f3 -d" " )  # for MacOS, just use the day value
  TODAY=$(date | cut -f3 -d" " )

  if [[ $TODAY != $FILE_DAY ]]; then
      rollOverLogs
  fi
}


function LogError() {
   checkForNewDay
   NOW=`date '+%Y-%m-%d %H:%M'`
   echo ${NOW} $HOSTNAME $0 "ERROR" $1 $2 $3 $4 >> ${ERROR_LOG}
}


function LogWarn() {
   checkForNewDay
   NOW=`date '+%Y-%m-%d %H:%M'`
   echo ${NOW} $HOSTNAME $0 "WARN " $1 $2 $3 $4 >> ${ERROR_LOG}
}


function LogInfo() {
   checkForNewDay
   NOW=`date '+%Y-%m-%d %H:%M'`
   echo ${NOW} $HOSTNAME $0 "INFO " $1 $2 $3 $4 >> ${ERROR_LOG}
}

#End of file
