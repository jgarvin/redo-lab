#!/bin/zsh

output_dir=$(dirname $0)

# TODO: This is inefficient, we want one find invocation.

for w in o d
do
    rm -f $(find $output_dir -name '*.'$w)
done

rm -f compile-args cpp-includes env-compile-args \
    libraries object-files libraries;

redo-always
