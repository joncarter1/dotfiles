#!/bin/bash

# Configuration
LOCAL_PORT=5000
HEAD_PORT=5000
NODE_PORT=5000
SLURM_JOB_NAME="mlflow"

if [ -z "$1" ]; then
    echo "Error: Cluster head node not provided.."
    exit 1
fi
CLUSTER_HEAD_NODE="$1"

# Cancel existing MLFlow instance
echo "Stopping existing instances..."
ssh $CLUSTER_HEAD_NODE "squeue --me -o '%.18i %.50j' | grep $SLURM_JOB_NAME | awk '{print \$1}' | xargs --no-run-if-empty scancel --clusters=all"

sleep 2
echo "Starting new instance..."

# Execute remote sbatch command. Use a login shell so system is correctly configured.
JOB_ID=$(ssh ${CLUSTER_HEAD_NODE} "bash -c 'sbatch --parsable <<EOT
#!/bin/bash
#SBATCH --job-name=${SLURM_JOB_NAME}
#SBATCH --time=720
#SBATCH --cpus-per-task=4
#SBATCH --mem 8GB
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH -o \${HOME}/slurm/%j.out
#SBATCH --clusters=${CLUSTERS}

source /etc/profile.d/modules.sh
module load Miniconda3/23.1.0-1

source activate ${SLURM_CONDA_ENV}
echo "Activated environment: ${SLURM_CONDA_ENV}."
ssh  \${USER}@${CLUSTER_HEAD_NODE} "echo 'SSH connection successful'" && echo "Connection OK" || (echo "Failed to SSH back to login node." && exit 1)
echo "Setting up reverse proxy"
ssh -f -N -R ${HEAD_PORT}:localhost:${NODE_PORT} \${USER}@${CLUSTER_HEAD_NODE} &
echo "Forwarded port ${NODE_PORT} to ${HEAD_PORT} on ${CLUSTER_HEAD_NODE}. Starting MLFlow...."
mlflow server -w 4 --gunicorn-opts="--timeout=90" --backend-store-uri ${SLURM_MLFLOW_STORAGE} --port ${NODE_PORT}
EOT
'")

JOB_ID=$(echo "${JOB_ID}" | sed 's/;.*//')
echo "Waiting for job ID: ${JOB_ID} to start..."

# Polling the job status
while true; do
    COMPUTE_NODE=$(ssh $CLUSTER_HEAD_NODE "bash -l -c 'squeue -j $JOB_ID -h -o %N --me'")

    if [ ! -z "$COMPUTE_NODE" ]; then
        echo "Job is running on $COMPUTE_NODE"
        break
    else
        echo "Job not started yet. Checking again in 10 seconds..."
        sleep 10
    fi
done

echo "Forwarding port from head node to local machine..."
ssh -L ${LOCAL_PORT}:localhost:${HEAD_PORT} ${CLUSTER_HEAD_NODE}