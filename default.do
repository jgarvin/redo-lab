# Build with cog if it's a cog target
if [ -f source-tree/$1$2.cog ]; then
    redo-ifchange source-tree/$1$2.cog
    mkdir -p $(dirname $1)

    target_dir="./source-tree/$(dirname $1)"
    old_target_dir=""
    python_path=""
    while [ ! "$target_dir" = "$old_target_dir" ]; do
	if [ -d $target_dir/cog-recipes ]; then
	    python_path="$target_dir/cog-recipes:$python_path"
	fi

	old_target_dir=$target_dir
	target_dir="${target_dir%/*}"
    done

    # TODO: We should detect $PYTHONPATH changes
    PYTHONPATH=$python_path:$PYTHONPATH cog source-tree/$1$2.cog
    exit $?
else
    redo-ifcreate source-tree/$1$2.cog
fi

# If it's a binary target build that
if [ ! -f source-tree/$1.target ]; then
    echo >&2 "no rule to make source-tree/$1.target"
    if [ -d $(dirname $1)/../src ]; then
	echo >&2 "You have a src/ subfolder though. Did you forget to make $1.target?"
    fi
    exit 1
fi

mkdir -p $(dirname $1)

redo-ifchange cog-targets
read cog_targets < cog-targets

redo-ifchange $cog_targets

redo-ifchange $1.object-files
read object_files < $1.object-files

redo-ifchange $object_files

$(cat cpp-compiler) $(cat compile-args) -o $3 $object_files
