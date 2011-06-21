# Don't depend on any details of the cpp-compiler, YET.
redo-ifchange cpp-compiler env-compile-args

options="$options $(cat env-compile-args)"

if [ -f source-tree/preprocessor-defines ]; then
    redo-ifchange source-tree/preprocessor-defines
    for i in $(cat source-tree/preprocessor-defines); do
        options="$options -D$i"
    done
else
    redo-ifcreate source-tree/preprocessor-defines
fi

redo-ifchange cpp-includes libraries

read includes < ./cpp-includes
for i in $includes; do
    options="$options -I$i"
done

read libraries < ./libraries
for i in $libraries; do
    options="$options -l$i"
done

# TODO: Need to put each option on its own line,
# rather than use spaces, so we can sort -u.
echo $options | tee >(redo-stamp)
