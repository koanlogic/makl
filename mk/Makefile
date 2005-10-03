# TODO 

test:
	for f in deps.mk incs.mk lib.mk prog.mk subdir.mk man.mk ; do \
    		for t in " " clean install uninstall depend cleandepend ; do \
        		cmd="make -f $$f -n $$t" ; \
        		echo "==> $$cmd" ; \
        		$$cmd 2>&1 ; \
        		echo ; \
    		done \
	done
