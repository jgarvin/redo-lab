# TODO: This is inefficient, we want one find invocation.
for w in o d pyc
do
    rm -f $(find . -name '*.'$w)
done

# Delete any generated binaries
for target in $(find -H source-tree -name '*.target'); do
    extless=${target%.target}
    relative_loc=./${extless#source-tree}
    rm -f $relative_loc
done

rm -f compile-args cpp-includes env-compile-args \
    libraries object-files libraries;

redo-always
