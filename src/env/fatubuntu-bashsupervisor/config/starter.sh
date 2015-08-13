#!/bin/bash

function myecho {
    if [ ! -z "$DEBUG" ]; then
        echo "$*"
    fi
}

function myecho_read {
    if [ ! -z "$DEBUG" ]; then
        while read data; do
          echo "$data"
        done
    fi
}

# @info
# used to find processes state (workaround for never-garbaged-zombie issue )
# @param
#  $1 = process id
# @return
#     "Z" if process is zombie
#      or  something else
getProcessStateFromId(){
    local PROC_ID=$1
    echo $( ps -o pid,state --pid $PROC_ID --no-headers | awk '{print $2}' )
}

# @info
# zombie process should be considere as closed (even if kill -0 will return success )
# @param
#  $1 = process id
# return
#     true if process exists,
# or  false
checkPidExist() {
    local PID_TO_CHECK=$1
    if [[ $PID_TO_CHECK -lt "1" ]]; then
        echo 'pid ( '$PID_TO_CHECK' ) not found ' >&2
        echo "false"
    fi
    local ZOMBIE_PROCESS_STATE='Z'
    kill -0 $PID_TO_CHECK 1>/dev/null 2>&1
    if [[ $? -eq "0" ]]; then #process id exists
        echo 'checking process state for id , '$PID_TO_CHECK' , state = >'$( getProcessStateFromId $PID_TO_CHECK)'<' >&2
        [[ $( getProcessStateFromId $PID_TO_CHECK) == "$ZOMBIE_PROCESS_STATE" ]] && echo "false" || echo "true"
    else
        echo "false"
    fi
    #[[ $? -eq "0" ]] && echo "true" || echo "false"
    #echo "true"
}

# capture signals
trap : SIGTERM SIGINT

echo $$


for init in /config/init*; do
    echo 'executing: '$init
    chmod +x $init ;
    bash "$init" &
    COMMAND_PID=$!
    wait $COMMAND_PID
    WAIT_RETURN=$?
    myecho 'starter.sh wait returned $? = '$WAIT_RETURN
    if [[ $WAIT_RETURN -gt 128 ]]
    then
        ps auxf | myecho_read
        echo 'process group killing > '${COMMAND_PID}
        kill -- ${COMMAND_PID}
        pidRunning=""
        wait_kill_counter=0

        echo '>>> WAITING PROCESS tree TO DIE... pidRunning = '$pidRunning
        until [[ "$pidRunning" == "false" ]]
        do
            pidRunning=$( checkPidExist $COMMAND_PID )
            echo 'pidRunning = '$pidRunning
            if [[ "$pidRunning" == "true" ]]; then # WAITING PROCESS TO DIE
                echo '>>> WAITING PROCESS tree TO DIE... '${wait_kill_counter}' SECONDS'
                ps auxf | myecho_read
                sleep 1
                echo 'PSVALUE= '$PSVALUE >&2
            else # KILL SUCCESS
                echo '[SUCCESS]  PROCESS tree killed successfully pid '$COMMAND_PID
                ps auxf | myecho_read
                break;
            fi
            wait_kill_counter=$[$wait_kill_counter+1]
        done

        ps auxf | myecho_read
        exit 0
    fi
done
