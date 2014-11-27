#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libtess2/Include/tesselator.h"
#include "libtess2.h"


void* poolAlloc(void* userData, unsigned int size) {
	MemPool* pool = (MemPool*)userData;
	if (pool->size + size < pool->cap) {
		unsigned char* ptr = pool->buf + pool->size;
		pool->size += size;
		return ptr;
	}
	return 0;
}

void poolFree(void* userData, void* ptr) {
}

TESStess* t;

void initBuffer(int size)
{
	t = (TESStess *)malloc(sizeof(TESStess));
	t->pool = (MemPool *)malloc(sizeof(MemPool));
	t->pool->buf = (unsigned char *)malloc(size);
	t->pool->cap = size;
	t->pool->size = 0;
	t->ma = (TESSalloc *)malloc(sizeof(TESSalloc));
	memset(t->ma, 0, sizeof(TESSalloc));
	t->ma->memalloc = poolAlloc;
	t->ma->memfree = poolFree;
	t->ma->userData = (void*)t->pool;
	t->ma->extraVertices = 256; // realloc not provided, allow 256 extra vertices.
}

void destroyBuffer() {
	tessDeleteTess(t->tess);
	free(t->ma);
	free(t->pool->buf);
	free(t->pool);
	free(t);
}

void newTess() {
	t->pool->size = 0;
	t->tess = tessNewTess(t->ma);
}

void addContour(int size, const void* pointer, int stride, int count) {
	tessAddContour(t->tess, size, pointer, stride, count);
}

int tesselate(int windingRule, int elementType, int polySize, int vertexSize) {
	return tessTesselate(t->tess, windingRule, elementType, polySize, vertexSize, NULL);
}

int getVertexCount() {
	return tessGetVertexCount(t->tess);
}

const TESSreal* getVertices() {
	return tessGetVertices(t->tess);
}

const TESSindex* getVertexIndices() {
	return tessGetVertexIndices(t->tess);
}

int getElementCount() {
	return tessGetElementCount(t->tess);
}

const TESSindex* getElements() {
	return tessGetElements(t->tess);
}
