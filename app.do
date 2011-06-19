redo-ifchange cpp-compiler compile-args object-files

read object_files < object-files

redo-ifchange $object_files

$(cat cpp-compiler) $(cat compile-args) -o $3 $object_files
