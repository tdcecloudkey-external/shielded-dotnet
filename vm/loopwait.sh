#!/bin/bash
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <sleep_time> <num_iterations> <image>"
    exit 1
fi

SLEEP_TIME=$1
NUM_ITERATIONS=$2
IMAGE=$3
COMMAND="docker run --rm --device=/dev/sgx_enclave -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket $IMAGE"
LOG_FILE="loop_log_$(date +%Y%m%d_%H%M%S).log"

{
echo "Starting loop..."
echo "Logging output to: $LOG_FILE"

for ((i=1; i<=NUM_ITERATIONS; i++))
do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$TIMESTAMP] Iteration $i: Running command: $COMMAND"

    # Execute command and append output to log
    eval "$COMMAND" 2>&1
    wait

    # Sleep before next iteration
    if [ "$i" -lt "$NUM_ITERATIONS" ]; then
        echo "sleeping"
        sleep "$SLEEP_TIME"
    fi
done

} | tee -a "$LOG_FILE"