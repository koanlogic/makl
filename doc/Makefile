TARGETS=../cf/makl_args \
    ../cf/makl_args_handle \
    ../cf/makl_code \
    ../cf/makl_conf \
    ../cf/makl_deps \
    ../cf/makl_libdep \
    ../cf/makl_utils \
    ../cf/makl_utils_tab \
    ../cf/makl_var

OUTPUT_DIR = dokl

all: dokl doxy img

dokl:
	mkdir -p ${OUTPUT_DIR};
	for arg in ${TARGETS}; do \
	    file=`basename $${arg}`; \
        echo "dokl processing '$${file}'"; \
		./dokl.sh $${arg} > ${PWD}/${OUTPUT_DIR}/$${file}.dokl; \
	done;
  
doxy:
	doxygen makl.doxy

img:
	mkdir -p html/images
	cp -r images html

clean:
	rm -rf ${OUTPUT_DIR} html
