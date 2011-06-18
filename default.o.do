source_dir=$(cat $(dirname $0)/source-tree)
output_dir=$(dirname $0)

mkdir -p $(dirname $1)

compile_args=$output_dir/compile-args

source_file=$source_dir/$1.cpp

redo-ifchange $compile_args $source_file $output_dir/cpp-includes

g++ $(cat $compile_args) -MD -MF $1.d -c -o $3 $source_file
read DEPS <$1.d
redo-ifchange ${DEPS#*:}
