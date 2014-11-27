all: check
	make all_targets
	
clean:
	rm -f *_wrapper.c *.swf *.swc *.abc libtess2.as libtess2_int.as
	
T01:
	"$(CB_SDK)/usr/bin/swig" -as3 -module libtess2 -outdir . -includeall -ignoremissing -o libtess2_wrapper.c libtess2.i

	$(AS3COMPILERARGS)\
		-abcfuture\
		-AS3\
		-import $(call nativepath,$(CB_SDK)/usr/lib/builtin.abc)\
		-import $(call nativepath,$(CB_SDK)/usr/lib/playerglobal.abc)\
		libtess2.as

	mv libtess2.abc olibtess2.abc

	$(AS3COMPILERARGS)\
		-abcfuture\
		-AS3\
		-import $(call nativepath,$(CB_SDK)/usr/lib/builtin.abc)\
		-import $(call nativepath,$(CB_SDK)/usr/lib/playerglobal.abc)\
		libtess2_wrapper.as

	mv libtess2_wrapper.abc olibtess2_wrapper.abc

	"$(CB_SDK)/usr/bin/gcc" $(BASE_CFLAGS)\
		-O4\
		olibtess2.abc\
		olibtess2_wrapper.abc\
		libtess2_wrapper.c\
		libtess2/Source/bucketalloc.c\
		libtess2/Source/dict.c\
		libtess2/Source/geom.c\
		libtess2/Source/mesh.c\
		libtess2/Source/priorityq.c\
		libtess2/Source/sweep.c\
		libtess2/Source/tess.c\
		libtess2.c\
		libtess2_main.c\
		-emit-swc=com.codeazur.libtess2.lib\
		-o libtess2.swc\
		-I./libtess2/Include

	mv libtess2.swc bin
	
T02:
	"$(CB_SDK)/usr/bin/swig" -as3 -module libtess2_int -outdir . -includeall -ignoremissing -o libtess2_int_wrapper.c libtess2_int.i

	$(AS3COMPILERARGS)\
		-abcfuture\
		-AS3\
		-import $(call nativepath,$(CB_SDK)/usr/lib/builtin.abc)\
		-import $(call nativepath,$(CB_SDK)/usr/lib/playerglobal.abc)\
		libtess2_int.as

	mv libtess2_int.abc olibtess2_int.abc

	$(AS3COMPILERARGS)\
		-abcfuture\
		-AS3\
		-import $(call nativepath,$(CB_SDK)/usr/lib/builtin.abc)\
		-import $(call nativepath,$(CB_SDK)/usr/lib/playerglobal.abc)\
		libtess2_int_wrapper.as

	mv libtess2_int_wrapper.abc olibtess2_int_wrapper.abc

	"$(CB_SDK)/usr/bin/gcc" $(BASE_CFLAGS)\
		-O4\
		-D use_int\
		olibtess2_int.abc\
		olibtess2_int_wrapper.abc\
		libtess2_int_wrapper.c\
		libtess2/Source/bucketalloc.c\
		libtess2/Source/dict.c\
		libtess2/Source/geom.c\
		libtess2/Source/mesh.c\
		libtess2/Source/priorityq.c\
		libtess2/Source/sweep.c\
		libtess2/Source/tess.c\
		libtess2.c\
		libtess2_main.c\
		-emit-swc=com.codeazur.libtess2_int.lib\
		-o libtess2_int.swc\
		-I./libtess2/Include

	mv libtess2_int.swc bin
	
all_targets: T01 T02 clean

include ./Makefile.common
