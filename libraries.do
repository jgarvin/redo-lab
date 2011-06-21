if [ ! -f source-tree/requires ]; then
    echo
    redo-ifcreate source-tree/requires
    exit 0
fi

redo-ifchange source-tree/requires
read requires < source-tree/requires

lib_scripts=""
for i in $requires; do
    if [ -f deps/$i-libraries.do ]; then
	    lib_scripts="$lib_scripts deps/$i-libraries"
    else
	    redo-ifcreate deps/$i-libraries.do
    fi
done

redo-ifchange $lib_scripts

libs=""
for i in $lib_scripts; do
    libs="$libs $(cat $i)"
done

# TODO: Need to use newlines instead of spaces
# for sort to matter
echo $libs | sort -u | tee >(redo-stamp)
