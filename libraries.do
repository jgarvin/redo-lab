read source_dir < $(dirname $0)/source-tree
output_dir=$(dirname $0)

if [ ! -f "$source_dir"/requires ]; then
    echo
    redo-ifcreate "$source_dir"/requires
    exit 0
fi

redo-ifchange "$source_dir"/requires
read requires < "$source_dir"/requires

lib_scripts=""
for i in $requires; do
    if [ -f "$output_dir"/deps/$i-libraries.do ]; then
	    lib_scripts="$lib_scripts "$output_dir"/deps/$i-libraries"
    else
	    redo-ifcreate "$output_dir"/deps/$i-libraries.do
    fi
done

redo-ifchange $lib_scripts

libs=""
for i in $lib_scripts; do
    libs="$libs $(cat "$output_dir"/$i)"
done

# TODO: Need to use newlines instead of spaces
# for sort to matter
echo $libs | sort -u | tee >(redo-stamp)
