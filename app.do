output_dir=$(dirname $0)

redo-ifchange $output_dir/cpp-compiler \
    $output_dir/compile-args \
    $output_dir/object-files

for obj in $(cat $output_dir/object-files); do
    object_files="$object_files $output_dir/$obj"
done

redo-ifchange $object_files

$(cat $output_dir/cpp-compiler) \
    $(cat $output_dir/compile-args) -o $3 \
    $object_files
