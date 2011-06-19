read source_dir < $(dirname $0)/source-tree
output_dir=$(dirname $0)

# Don't depend on any details of the cpp-compiler, YET.
redo-ifchange $output_dir/cpp-compiler $output_dir/env-compile-args

options="$options $(cat $output_dir/env-compile-args)"

if [ -f $source_dir/preprocessor-defines ]; then
    redo-ifchange $source_dir/preprocessor-defines
    for i in $(cat $source_dir/preprocessor-defines); do
        options="$options -D$i"
    done
else
    redo-ifcreate $source_dir/preprocessor-defines
fi

global_includes_file=$output_dir/cpp-includes
global_libraries_file=$output_dir/libraries

redo-ifchange $global_includes_filex $global_libraries_file

read includes < $global_includes_file
for i in $includes; do
    options="$options -I$i"
done

read libraries < $global_libraries_file
for i in $libraries; do
    options="$options -l$i"
done

# TODO: Need to put each option on its own line,
# rather than use spaces, so we can sort -u.
echo $options | tee >(redo-stamp)
