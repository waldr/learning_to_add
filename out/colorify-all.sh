#!/bin/bash

# This script generates colored versions of the experiments output files,
# highlighting character prediction errors.
# Both plain files and html are generated.
# The first type can be inspected with "less -R <filename>"
#
# Usage: $colorify-all.sh <file list> <output directory>

array=( "$@" )
out_dir=${@:$#}
unset "array[${#array[@]}-1]"    # Removes last element from argument list
mkdir -p $out_dir
for i in "${array[@]}"; do
	echo "Processing ${i%.*}"
	python colorify.py $i > "$out_dir/$i"
	cat "$out_dir/$i" | aha > "$out_dir/${i%.*}.html" 
done
