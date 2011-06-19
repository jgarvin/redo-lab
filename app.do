redo-ifchange cpp-compiler compile-args object-files

for obj in $(cat object-files); do
    object_files="$object_files $obj"
done

redo-ifchange $object_files

$(cat cpp-compiler) $(cat compile-args) -o $3 $object_files
