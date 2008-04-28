#!/bin/sh

function err ()
{
    echo $@
    exit 1
}

[ -x `which checkbashisms` ] || err "checkbashisms tool not found"

for i in makl_* makl.* helpers/makl_*
do 
    tmpf="/tmp/`basename $i`"
    echo '#!/bin/sh' > ${tmpf}
    cat $i >> ${tmpf}
    checkbashisms ${tmpf}
    rm ${tmpf}
done
