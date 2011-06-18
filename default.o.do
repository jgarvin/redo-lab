source_dir=$(cat $(dirname $0)/source-tree)
output_dir=$(dirname $0)

mkdir -p $(dirname $1)

compile_args=$output_dir/compile-args

source_file=$source_dir/$1.cpp

redo-ifchange $compile_args $source_file $output_dir/cpp-includes

file_specific_options=""
specific_define_file=$source_dir/$(dirname $1)/$(basename $1).preprocessor-defines >&2
if [ -f $specific_define_file ]; then
    redo-ifchange $specific_define_file
    for i in $(cat $specific_define_file); do
        file_specific_options="$file_specific_options -D$i"
    done
else
    redo-ifcreate $specific_define_file
fi

g++ $(cat $compile_args) $file_specific_options -MD -MF $1.d -c -o $3 $source_file
read DEPS <$1.d
redo-ifchange ${DEPS#*:}
