if [ ! -f source-tree/$1.target ]; then
    echo >&2 "no rule to make $1"
    if [ -d $(dirname $1)/../src ]; then
	echo >&2 "You have a src/ subfolder though. Did you forget to make $1.target?"
    fi
    exit 1
fi

mkdir -p $(dirname $1)

redo-ifchange $1.object-files

read object_files < $1.object-files

redo-ifchange $object_files

$(cat cpp-compiler) $(cat compile-args) -o $3 $object_files
