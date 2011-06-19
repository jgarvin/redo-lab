read source_dir < $(dirname $0)/source-tree
output_dir=$(dirname $0)

sources=`find $source_dir -iname '*.cpp'`

for s in $sources
do
    relative_loc=./${s#$source_dir}
    extless=${relative_loc%.*}

    # TODO: Is this the right place to do this?
    mkdir -p $(dirname $s)

    object_files="$object_files $extless.o"
done

echo $object_files | sort -u | tee >(redo-stamp)
redo-always
