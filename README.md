# Wazuh Agent Name Updater

This script updates the names of all agents in Wazuh to match the current hostnames of the computers they are running on.

## Prerequisites

- Access to the Wazuh manager server.
- Ensure you have the necessary permissions to run Wazuh commands and modify agent settings.

## Usage

1. **Clone the repository or copy the script to your Wazuh manager server**.

2. **Make the script executable**:
   ```sh
   chmod +x update_agent_names.sh
   ```

3. **Run the script with sudo**:
   ```sh
   sudo ./update_agent_names.sh
   ```

The script performs the following steps:

1. **Fetches the list of all agents** and saves it to `agents_list.txt`.
2. **Collects the current hostnames** of all agents and saves them to `hosts_list.txt`.
3. **Updates the agent names** in Wazuh to match the collected hostnames.

## Explanation

- The script changes to the `/var/ossec/bin` directory where the Wazuh binaries are located.
- It retrieves the list of agents using `./agent-control -ls`.
- For each agent, it fetches the current hostname using `./agent-control -i AGENT_ID`.
- It then updates the agent name in Wazuh using `./agent-control -r AGENT_ID -n HOSTNAME`.

## Debugging

The script runs in debug mode (`set -x`), which prints each command before executing it. This helps in understanding the script's flow and diagnosing any issues.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
