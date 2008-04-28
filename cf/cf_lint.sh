#!/bin/sh

function err ()
{
    echo $@
    exit 1
}

cb="`which checkbashisms`"
[ $? = 0 ] || err "checkbashisms tool not found"
[ -x "${cb}" ] || err "checkbashism is not executable"

for i in makl_* makl.* helpers/makl_*
do 
    tmpf="/tmp/`basename $i`"
    echo '#!/bin/sh' > ${tmpf}
    cat $i >> ${tmpf}
    ${cb} ${tmpf}
    rm ${tmpf}
done
