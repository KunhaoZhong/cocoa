#!/bin/bash

# Path to the file you want to delete
FILE_TO_DELETE="./projects/des_y3/chains/GG_MCMC4.input.yaml.locked"

# Command you want to run
COMMAND="mpirun -n 4 --oversubscribe cobaya-run ./projects/des_y3/GG_MCMC4.yaml -r"

# Number of runs
NUM_RUNS=50

for ((i=1; i<=NUM_RUNS; i++)); do
    echo "[$i/$NUM_RUNS] Starting command..."
    $COMMAND

    echo "[$i/$NUM_RUNS] Command finished. Cleaning up..."
    if [ -f "$FILE_TO_DELETE" ]; then
        rm "$FILE_TO_DELETE"
        echo "Deleted $FILE_TO_DELETE"
    else
        echo "No $FILE_TO_DELETE found"
    fi

    if [ $i -lt $NUM_RUNS ]; then
        echo "Waiting 10 seconds before next run..."
        sleep 10
    fi
done

echo "All $NUM_RUNS runs completed."