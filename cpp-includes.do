if [ -d source-tree/include ]; then
    echo source-tree/include | tee >(redo-stamp)
else
    # TODO: Does redo-ifcreate work for directories?
    redo-ifcreate source-tree/include
fi

if [ ! -f source-tree/requires ]; then
    redo-ifcreate source-tree/requires
    exit 0
fi

redo-ifchange source-tree/requires
read requires < source-tree/requires

header_scripts=""
for i in $requires; do
    if [ -f deps/$i-headers.do ]; then
	header_scripts="$header_scripts deps/$i-headers"
    else
	redo-ifcreate deps/$i-headers.do
    fi
done

redo-ifchange $header_scripts

headers=""
for i in $header_scripts; do
    headers="$headers $(cat $i)"
done

# TODO: Need to use newlines instead of spaces
# for sort to matter
echo $headers | sort -u | tee >(redo-stamp)
