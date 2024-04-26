#!/bin/bash

# This script can be used to set up an SSH server on a Slurm cluster compute node that can then be used for a remote VSCode instance.

# Example usage:
# §./vscode.sh CLUSTER_HEAD_NODE` followed by `ssh remote-vscode` to connect to the instance.

# It is assumed that:
#   1. You have SSH keys set-up for passwordless login.
#   2. You have an entry in ~/.ssh/config so that 'ssh ${CLUSTER_HEAD_NODE}' works.
#   3. You have an entry in ~/.ssh/config of the form:
#   Host remote-vscode
#       ProxyCommand ssh CLUSTER_HEAD_NODE "nc \$(squeue --me --name=vscode --states=R -h -O NodeList) \$(scontrol show job $(squeue --noheader --name=vscode --user \$USER --format=%%A) | grep Comment | cut -d= -f2)"
#       StrictHostKeyChecking no
#       User CLUSTER_USER

# Configuration variables
# You should change this to a random port, to avoid any conflicts with others using the cluster.
REMOTE_SSHD_PORT=19852
SLURM_JOB_NAME="vscode"
CLUSTERS="all" # Run on any available cluster under Slurm management.

if [ -z "$1" ]; then
    echo "Error: Cluster head node not provided.."
    exit 1
fi
CLUSTER_HEAD_NODE="$1"

echo "Stopping existing VSCode instances..."
ssh $CLUSTER_HEAD_NODE "squeue -u \$USER -o '%.18i %.50j' --clusters=all | grep $SLURM_JOB_NAME | awk '{print \$1}' | xargs --no-run-if-empty scancel --clusters=$CLUSTERS"

# Submit the Slurm job to start an SSHD on a compute node.
echo "Submitting the Slurm job to start VSCode..."
JOB_ID=$(ssh $CLUSTER_HEAD_NODE "sbatch --parsable  --job-name=$SLURM_JOB_NAME --comment=$REMOTE_SSHD_PORT --time=12:00:00 --output=\${HOME}/slurm/%j.out --cpus-per-task=8 --mem=32GB --partition=short --nodes=1 --wrap='/usr/sbin/sshd -D -p '"$REMOTE_SSHD_PORT"' -f /dev/null -h \${HOME}/.ssh/id_rsa'")
# Wait for the job to start.
echo "Waiting for job ID: ${JOB_ID} to start..."
sleep 10

# Polling the job status
while true; do
    COMPUTE_NODE=$(ssh $CLUSTER_HEAD_NODE "squeue -j $JOB_ID -h -o '%N'")
    if [ ! -z "$COMPUTE_NODE" ]; then
        echo "Job is running on $COMPUTE_NODE"
        break
    else
        echo "Job not started yet. Checking again in 10 seconds..."
        sleep 10
    fi
done

echo "Adding port comment" # --comment flag is initially overriden on the cluster I use.
ssh $CLUSTER_HEAD_NODE "scontrol update job $JOB_ID comment=$REMOTE_SSHD_PORT"

echo "SSH tunnel established! SSH Server running on $COMPUTE_NODE port $REMOTE_SSHD_PORT."
echo "Connect with 'ssh -J ${CLUSTER_HEAD_NODE} -p ${REMOTE_SSHD_PORT} ${COMPUTE_NODE}'\
 or 'ssh remote-vscode' after configuring '~/.ssh/config' as shown at the top of this script."
