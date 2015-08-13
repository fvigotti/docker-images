#!/bin/bash
clean_up() {
# Perform program exit housekeeping
echo '[----  TEST SUCCESS --------]   >>>>>>>>>> main application received termination signal!'
echo '[TRAPPED] '$1'closing program, pid =  '$$;
sleep 1
exit 0
}

trap "clean_up SIGHUP" SIGHUP
trap "clean_up SIGINT" SIGINT
trap "clean_up SIGTERM" SIGTERM
trap "clean_up SIGKILL" SIGKILL


# trap \"{ echo Booh; sleep 10 ;  }\" SIGINT SIGTERM
echo 'pid is '$$;

while :	
do
  sleep 5;
  echo 'TEST APP1 INTERNAL RUNNING OUTPUT SIMULATION ...' `date`;
done