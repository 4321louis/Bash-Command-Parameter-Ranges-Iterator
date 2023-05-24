#!/bin/bash 
source ../BashCommandParameterRangesIterator.sh

declare -A paramRanges=(
  ["Embryonic_cas9_eff"]=$(seq 0.0 0.1 1.0),
  ["Release_freq"]=$(seq 0.01 0.01 0.20),
  ["wwn"]=$(seq 0 1 1)
)

runOverRanges "echo %s Inversion_drive.slim" "-d" paramRanges