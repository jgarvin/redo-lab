header_scripts=""

# Add any includes from dependencies.
if [ -f source-tree/requires ]; then
    redo-ifchange source-tree/requires
    read requires < source-tree/requires

    for i in $requires; do
	if [ -f deps/$i-headers.do ]; then
	    header_scripts="$header_scripts deps/$i-headers"
	else
	    redo-ifcreate deps/$i-headers.do
	fi
    done
else
    redo-ifcreate source-tree/requires
fi

redo-ifchange $header_scripts

headers=""
for i in $header_scripts; do
    headers="$headers $(cat $i)"
done

# Add generated headers, if any. Assume these
# should override the source ones if they conflict
# so they come first.
if [ -d ./include ]; then
    headers="$headers ./include"
else
    # TODO: Does redo-ifcreate work for directories?
    redo-ifcreate ./include
fi

# Add include from the source tree.
if [ -d source-tree/include ]; then
    headers="$headers source-tree/include"
else
    # TODO: Does redo-ifcreate work for directories?
    redo-ifcreate source-tree/include
fi

# TODO: Need to use newlines instead of spaces
# for sort to matter
echo $headers | sort -u | tee >(redo-stamp)
