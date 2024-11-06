#!/bin/bash
#SBATCH -Jskimokitchen          # job name
#SBATCH -N1 --ntasks-per-node=1 # number of nodes and cores per node
#SBATCH --gres=gpu:V100:1        # GPU and number of GPUs
#SBATCH --mem-per-gpu=64GB       # memory per CPU core
#SBATCH -t16:00:00               # time limit
#SBATCH -oReport-%j.out         # Combined output and error messages file
#SBATCH --mail-type=BEGIN,END,FAIL # Mail preferences
#SBATCH --mail-user=atrinh31@gatech.edu # Mail address

cd ~/scratch/skimo

eval "$(conda shell.bash hook)"
module load anaconda3
module load cuda

conda activate skimo_venv

# Add MuJoCo environment variables
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.mujoco/mujoco210/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/nvidia
export MUJOCO_PY_MUJOCO_PATH=$HOME/.mujoco/mujoco210

wandb login --relogin

export WANDB_ENTITY="aarontrinh02-georgia-institute-of-technology"
export WANDB_PROJECT="p-skill-model"
export WANDB_API_KEY="531fce769e43363414f995984f1b8fe15c97a6e1"

srun python run.py --config-name skimo_kitchen run_prefix=test.1 gpu=0 wandb=true rolf.phase=rl rolf.pretrain_ckpt_path=log/kitchen.skimo.pretrain.test.0/ckpt/kitchen_ckpt_00000085000.pt