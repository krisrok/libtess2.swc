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

void initBuffer(int size);
void destroyBuffer();

void newTess();

void addContour(int size, const void* pointer, int stride, int count);

int tesselate(int windingRule, int elementType, int polySize, int vertexSize);

int getVertexCount();

const TESSreal* getVertices();

const TESSindex* getVertexIndices();

int getElementCount();

const TESSindex* getElements();

#ifdef __cplusplus
};
#endif
