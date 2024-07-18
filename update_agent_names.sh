#!/bin/bash

# Enable debug mode
set -x

# File with the list of agents
AGENTS_LIST="agents_list.txt"

# Output file with hostnames
HOSTS_LIST="hosts_list.txt"

# Change to the /var/ossec/bin directory
echo "Changing to /var/ossec/bin directory..."
cd /var/ossec/bin

# Step 1: Check the list of agents and save it to a file
echo "Checking the list of agents..."
./agent-control -ls > $AGENTS_LIST
echo "Agent list has been saved to $AGENTS_LIST"

# Clear the output file with hostnames
> $HOSTS_LIST

# Step 2: Collect the current hostnames of agents
echo "Collecting current hostnames of agents..."
while read -r agent; do
    # Get the agent ID
    AGENT_ID=$(echo $agent | awk '{print $1}')
    
    # Skip header lines and empty lines
    if [[ "$AGENT_ID" == *ID* || -z "$AGENT_ID" ]]; then
        continue
    fi
    
    # Get the hostname of the agent
    echo "Retrieving hostname for agent $AGENT_ID..."
    HOSTNAME=$(./agent-control -i $AGENT_ID | grep 'Name' | awk '{print $2}')
    
    # Save the agent ID and hostname to the file
    echo "Saving: $AGENT_ID $HOSTNAME to $HOSTS_LIST"
    echo "$AGENT_ID $HOSTNAME" >> $HOSTS_LIST
    echo "Collected hostname for agent $AGENT_ID: $HOSTNAME"
done < $AGENTS_LIST

echo "Finished collecting hostnames. Data saved to $HOSTS_LIST"

# Step 3: Update agent names
echo "Updating agent names..."
while read -r line; do
    # Get the agent ID and hostname
    AGENT_ID=$(echo $line | awk '{print $1}')
    HOSTNAME=$(echo $line | awk '{print $2}')
    
    # Update the agent name
    echo "Updating agent name $AGENT_ID to $HOSTNAME..."
    ./agent-control -r $AGENT_ID -n $HOSTNAME
    echo "Updated agent name $AGENT_ID to $HOSTNAME"
done < $HOSTS_LIST

echo "Agent name update completed."
