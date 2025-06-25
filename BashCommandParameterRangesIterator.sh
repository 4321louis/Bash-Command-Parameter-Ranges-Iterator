#!/bin/bash 
runOverRangesRecursive() {
	local command=$1
	local flag=$2
    local length=$3
	local paramIndex=$4
	local accumulatedParams=$5
	local accumulatedPatternToIgnore=$6

	# base case
	if ((length <= paramIndex)); then
		if [ -n "$minAmountForIgnore" ]; then
			amountMatching="$(grep -c $accumulatedPatternToIgnore $fileWithDataPointsToIgnore)"
			if [ "$amountMatching" -ge "$minAmountForIgnore" ]; then
				return 0
			fi
		fi
		result=$(echo "${accumulatedParams%?}")
		$(printf "$command\n" "$result")
		return 0
	fi

	
	local range="${listOfRanges[$paramIndex]}"
	for v in $range
	do
		newParams="$accumulatedParams$flag ${listOfParams[$paramIndex]}=$v"
        runOverRangesRecursive "$command" "$flag" "$length" $((paramIndex+1)) "$newParams " "${accumulatedPatternToIgnore/${listOfParams[$paramIndex]}/$v}"
	done
	
}


runOverRanges() {
    local command=$1
    local flag=$2
    declare -n listOfParamRanges=$3
	local length="${#listOfParamRanges[@]}"
	listOfParams=("${!listOfParamRanges[@]}")
	listOfRanges=("${listOfParamRanges[@]}")
	paramOrdering=$4
	fileWithDataPointsToIgnore=$5
	minAmountForIgnore=$6
	# remove weird commas
	for ((i = 0; i < length; i++)); do
		echo $i
		listOfRanges[$i]=$(echo "${listOfRanges[$i]}" | tr -d ',')
	done
	
	runOverRangesRecursive "$command" "$flag" "$length" 0 "" "$paramOrdering"
}

