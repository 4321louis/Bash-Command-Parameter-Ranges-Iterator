#!/usr/local/easybuild-2019/easybuild/software/compiler/gcc/11.2.0/bash/4.3/bin/bash
# Created by the University of Melbourne job script generator for SLURM
# Thu May 18 2023 02:25:29 GMT+1000 (Australian Eastern Standard Time)

# # # Settings for Sbatch

# Partition for the job:
#SBATCH --partition=physical

# Multithreaded (SMP) job: must run on one node 
#SBATCH --nodes=1

# The name of the job:
#SBATCH --job-name="LoadedIsolatedFoundingPopulation"

# The project ID which this job should run under:
#SBATCH --account="punim2001"

# Maximum number of tasks/CPU cores used by the job:
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

# Use this email address:
#SBATCH --mail-user=louis.nowellnicolle@student.unimelb.edu.au

# Send yourself an email when the job:
# aborts abnormally (fails)
#SBATCH --mail-type=FAIL
# ends successfully
#SBATCH --mail-type=END

# log output files
#SBATCH -o logs/slurm.%N.%j.out # STDOUT 
#SBATCH -e logs/slurm.%N.%j.err # STDERR

# The maximum running time of the job in days-hours:mins:sec
#SBATCH --time=1-0:0:00
# Parralelise the computation
#SBATCH --array=1-100

# # # File and version checks 

# Run the job from this directory:
cd /home/lnowellnicol/punim2001/DP23-Allee-Drive-Modeling

# check that the script is launched with sbatch
if [ "x$SLURM_JOB_ID" == "x" ]; then
   echo "You need to submit your job to the queuing system with sbatch"
   exit 1
fi

# Check if the bash version is lower than 4.3.0 since we use associative arrays
if [[ "${BASH_VERSION}" < "4.3.0" ]]; then
    echo "Error: Bash version 4.3.0 or higher is required. Please edit the first line of the script to point to it"
    exit 1
fi

# Write csv header if outputfile doesnt exist
outputFile="out.csv"
if [ ! -f "$outputFile" ]; then
   echo "Result,Embryonic_cas9_eff,Release_freq,wwn" >> "$outputFile"
fi

# check sources
bcpriSourcePath="../BashCommandParameterRangesIterator.sh"
if [ ! -f "$bcpriSourcePath" ]; then
    echo "Error: Bash-Command-Parameter-Ranges-Iterator not found please download from https://github.com/4321louis/Bash-Command-Parameter-Ranges-Iterator and edit this script to point to it"
    exit 1
fi

# # # run job code

# Source files
module load slim/4.0.1
source $bcpriSourcePath

declare -A paramRanges=(
  ["Embryonic_cas9_eff"]=$(seq 0.0 0.1 1.0)
  ["Release_freq"]=$(seq 0.01 0.01 0.20)
  ["wwn"]=$(seq 0 1 1)
)

runOverRanges "echo -seed ${SLURM_ARRAY_TASK_ID} -d outputFilePath='$outputFile' %s LoadedIsolatedFoundingPopulation.slim" "-d" paramRanges

##DO NOT ADD/EDIT BEYOND THIS LINE##
##Job monitor command to list the resource usage
my-job-stats -a -n -s

