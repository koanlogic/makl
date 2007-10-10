TARGETS =  $(wildcard ../cf/makl_*)
TARGETS += $(wildcard ../cf/helpers/makl_*)

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
