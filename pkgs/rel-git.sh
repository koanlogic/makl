#!/bin/sh
#
# MaKL release script

# set these !
REL_TAG="MAKL_REL_1_9_0"
REL_VERSION="1.9.0"

REL_ROOT="makl"

REL_DIR="/tmp/MAKL_REL"
REL_TMP_DIR="${REL_DIR}/tmp"
REL_OUT_DIR="${REL_DIR}/out"

REL_HOST="gonzo.koanlogic.com"
REL_HOST_DIR="/var/www-anemic/www/download/makl/"
REL_TARGET="${REL_HOST}:${REL_HOST_DIR}"

yesno ()
{
    /bin/echo -n "$1 " 
    
    while [ true ] 
    do 
        read answer
        case ${answer} in
            [Yy]) return 0 ;;
            [nN]) return 1 ;;
            *) /bin/echo -n "please say [yY] or [nN]: " ;;
        esac
    done 
}       

err ()
{
    /bin/echo $@
    exit 1
}

make_pre() 
{
    rm -rf ${REL_TMP_DIR}
    mkdir -p ${REL_TMP_DIR} || err "can't create directory ${REL_TMP_DIR}"
    mkdir -p ${REL_OUT_DIR} || err "can't create directory ${REL_OUT_DIR}"
}

make_tag()
{
    yesno "using tag \"${REL_TAG}\", do you want to continue (y/n)?" \
        || err "bailing out on client request"

    echo "==> tagging as \"${REL_TAG}\""
    git tag -f ${REL_TAG} || err "git tag command failed"
    git push --tags origin master || err "git push command failed"
}

make_export()
{
    echo "==> exporting tagged tree"
    pushd .
    cd ${REL_TMP_DIR} || err "can't cd to ${REL_TMP_DIR}"
    git clone git://github.com/koanlogic/makl.git || err "git clone failed!"
    cd ${REL_ROOT} || err "can't cd to ${REL_ROOT}"
    git checkout -b ${REL_TAG} || err "git checkout failed!"
    popd
}

make_dist()
{
    echo "==> creating dist"

    pushd .
    cd ${REL_TMP_DIR}/${REL_ROOT} \
        || err "can't cd to ${REL_TMP_DIR}/${REL_ROOT}"

    # we need doxygen path
    /bin/sh configure.sh || err "configure.sh failed!"
    make -I `pwd`/mk -C doc/man clean install-hook-pre || 
        err "failed building docs!"
    make -I `pwd`/mk -f Makefile.dist || err "dist failed!"

    cp makl-${REL_VERSION}.* ${REL_OUT_DIR} \
        || err "can't copy dist files to ${REL_OUT_DIR}"
    popd
}

make_upload()
{
    local rcmd;

    rcmd="cd ${REL_HOST_DIR} && chgrp www-data makl-${REL_VERSION}.* && \
          ../mklatest.sh makl ${REL_VERSION}"

    echo "==> uploading release"

    # upload 
    scp -r ${REL_OUT_DIR}/makl-${REL_VERSION}.* root@${REL_TARGET} \
        || err "can't copy dist files to ${REL_TARGET}"

    # update -latest (this also extract ChangeLog from package)
    ssh root@${REL_HOST} ${rcmd} \
        || err "can't create -latest link on ${REL_HOST}"
}

make_clean()
{
    echo "==> clean up"
    rm -rf ${REL_DIR}
}

make_pre
make_tag
make_export
make_dist
make_upload
make_clean
