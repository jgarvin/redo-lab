mkdir -p $(dirname $1)

redo-ifchange $compiler_file compile-args \
    $source_file cpp-includes

read compile_args < ./compile-args
read compiler < ./cpp-compiler

source_file=source-tree/$1.cpp

file_specific_options=""
specific_define_file=source-tree/${1%.o}.preprocessor-defines
if [ -f $specific_define_file ]; then
    redo-ifchange $specific_define_file
    for i in $(cat $specific_define_file); do
        file_specific_options="$file_specific_options -D$i"
    done
else
    redo-ifcreate $specific_define_file
fi

$compiler $compile_args \
    $file_specific_options -MD -MF $1.d -c -o $3 $source_file

read DEPS <$1.d
redo-ifchange ${DEPS#*:}
