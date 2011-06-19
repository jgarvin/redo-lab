input_dir=.

read source_dir < $(dirname $0)/source-tree
output_dir=$(dirname $0)

old_pwd=$PWD

cd "$source_dir"
sources=`find . -name '*.cpp'`
cd $old_pwd

for s in $sources
do
    extless=$(basename $s | awk -F. '{ print $(NF-1) }')

    # TODO: Is this the right place to do this?
    mkdir -p "$output_dir"/$(dirname $s)

    object_files="$object_files "$output_dir"/$(dirname $s)/$extless.o"
done

echo $object_files | sort -u | tee >(redo-stamp)
redo-always
