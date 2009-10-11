# --- Required interface definitions ---

OBJ=o
LOBJ=o

# Usage: $(call libname,base)
define libname
lib$(1).a
endef

# Usage: $(call binname,base)
define binname
$(1).exe
endef

# --- Required rule definitions ---

#                       1   2
# Usage: $(call compile,src,includes)
define compile
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) \
		$(call depflags,$(basename $(call src_to_obj,$(1)))) \
		$(foreach I,$(2),-I$(I)) \
		-c $(1) -o $(call src_to_obj,$(1))
endef

#                       1   2
# Usage: $(call c_compile,src,includes)
define c_compile
	$(CC) $(CPPFLAGS) $(CFLAGS) \
		$(call depflags,$(basename $(call src_to_obj,$(1)))) \
		$(foreach I,$(2),-I$(I)) \
		-c $(1) -o $(call c_src_to_obj,$(1))
endef

libcompile = $(compile)
c_libcompile = $(c_compile)

#                        1    2
# Usage: $(call makeslib,objs,library)
define makeslib
	$(RM) $2
	$(AR) cru $(2) $(1)
	$(RANLIB) $(2)
endef

#                       1    2       3       4    5       6        7
# Usage: $(call makelib,objs,library,ldflags,libs,current,revision,age)
define makelib
	dlltool -l $(2) -D $$(basename `echo $(2) | sed -e 's,/lib\(.*\).a,/\1,'`$(5).dll) $(1); \
	$(CXX) -shared -static-libgcc -o `echo $(2) | sed -e 's,/lib\(.*\).a,/\1,'`$(5).dll \
		$(1) $(3) $(4)
endef

#                       1    2      3       4
# Usage: $(call makebin,objs,binary,ldflags,libs)
define makebin
	$(CXX) $(CXXFLAGS) $(1) -o $(2) $(3) $(4)
endef
