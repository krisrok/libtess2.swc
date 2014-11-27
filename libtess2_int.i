#ifdef SWIG
  %module libtess2_int
  %{
    typedef int TESSreal;
    typedef int TESSindex;
    typedef struct TESStesselator TESStesselator;
    typedef struct TESSalloc TESSalloc;
    #include "libtess2.h"
  %}
  %include "libtess2.h"
#else
  #include "libtess2/Include/tesselator.h"
  #include "libtess2.h"
#endif
