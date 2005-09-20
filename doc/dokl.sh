#!/bin/sh

is_comm=0

die ()
{
    shift 

    echo $*
    exit $1
}

help ()
{
    echo "Usage: dokl <input file>"
    die 1 
}


[ $1 ] || help
[ -r $1 ] || die 1 "Input file unreadable"

file=`basename $1`
echo "namespace ${file} {"

cat $1 | while read -r line; do

    # multi-line comments
    comm=`echo ${line} | grep "##"` 
    if [ $? -eq 0 ]; then
        if [ ${is_comm} -eq 0 ]; then
            echo -n "/**"
        else
            echo -n "*"
        fi
        is_comm=1

        echo ${line} | sed 's/##//'
    else
        if [ ${is_comm} -eq 1 ]; then
            echo "*/"
            is_comm=0
        fi

        # single-line comments
        comm=`echo ${line} | grep "#"` 
        if [ $? -eq 0 ]; then 
            echo ${line} | sed 's/#/\/\//'
        else
            echo ${line}
        fi
    fi
done

echo "}"
echo "/** \\namespace ${file}"
echo "\\brief Module \"${file}\" */"

