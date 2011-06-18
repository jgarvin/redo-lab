if test $USE_DEBUG; then
    options="$options -g"
fi

case $USE_OPTIMIZATION in
    "on") ;&
    "yes")
        options="$options -O2"
        ;;
    "off") ;&
    0)
        ;;
    *)
        if test $USE_OPTIMIZATION; then
            options="$options -O$USE_OPTIMIZATION"
        fi
        ;;
esac

echo $options | tee >(redo-stamp)
redo-always
