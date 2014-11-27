#ifdef __cplusplus
extern "C" {
#endif

typedef struct sMemPool {
  unsigned char* buf;
  unsigned int cap;
  unsigned int size;
} MemPool;

typedef struct sTESStess {
  TESStesselator* tess;
  TESSalloc* ma;
  MemPool* pool;
} TESStess;

TESStess* initBuffer(int size);
void destroyBuffer(TESStess* t);

void newTess(TESStess* t);

void addContour(TESStess* t, int size, const void* pointer, int stride, int count);

int tesselate(TESStess* t, int windingRule, int elementType, int polySize, int vertexSize);

int getVertexCount(TESStess* t);

const TESSreal* getVertices(TESStess* t);

const TESSindex* getVertexIndices(TESStess* t);

int getElementCount(TESStess* t);

const TESSindex* getElements(TESStess* t);

#ifdef __cplusplus
};
#endif
