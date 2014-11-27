package com.codeazur.libtess2
{
  import com.codeazur.libtess2.lib.*;

  public class Tesselator
  {
    public static const WINDING_ODD:int = 0;
    public static const WINDING_NONZERO:int = 1;
    public static const WINDING_POSITIVE:int = 2;
    public static const WINDING_NEGATIVE:int = 3;
    public static const WINDING_ABS_GEQ_TWO:int = 4;

    public static const ELEMENT_TYPE_POLYGONS:int = 0;
    public static const ELEMENT_TYPE_CONNECTED_POLYGONS:int = 1;
    public static const ELEMENT_TYPE_BOUNDARY_CONTOURS:int = 2;

    private var _type:int;
    private var _polySize:int;
    private var _vertexSize:int;

    public function Tesselator() {
      CModule.startAsync(this);
    }
		
		public function initBuffer(memorySize:int):void {
			libtess2.initBuffer(memorySize);
		}
		
		public function destroyBuffer():void {
      libtess2.destroyBuffer();
    }

    public function newTess():void {
			libtess2.newTess();
    }
    
    public function addContour(vertices:Vector.<int>, vertexCount:int = -1, vertexSize:int = 2):void {
      vertexSize = Math.min(Math.max(vertexSize, 3), 2);
      vertexCount = (vertexCount < 0) ? vertices.length / vertexSize : Math.min(vertexCount, vertices.length / vertexSize);
      var len:int = vertexCount * vertexSize;
      var ptr:int = CModule.malloc(4 * len);
			CModule.writeIntVector(ptr, vertices);
      //for (var i:int = 0, p:int = ptr; i < len; i++) {
        //CModule.writeFloat(p, vertices[i]);
        //p += 4;
      //}
      libtess2.addContour(vertexSize, ptr, 4 * vertexSize, vertexCount);
      CModule.free(ptr);
    }

    public function tesselate(windingRule:int, elementType:int, polySize:int = 3, vertexSize:int = 2):int {
      _type = elementType;
      _polySize = (elementType == ELEMENT_TYPE_BOUNDARY_CONTOURS) ? 2 : polySize;
      _vertexSize = Math.min(Math.max(vertexSize, 3), 2);;
      return libtess2.tesselate(windingRule, _type, _polySize, _vertexSize);
    }

    public function getVertexCount():int {
      return libtess2.getVertexCount();
    }

    public function getVertices():Vector.<int> {
      var len:int = getVertexCount() * _vertexSize;
      var ptr:int = libtess2.getVertices();
			return CModule.readIntVector(ptr, len);
      //var vertices:Vector.<Number> = new Vector.<Number>(len);
      //for (var i:int = 0; i < len; i++) {
        //vertices[i] = CModule.readFloat(ptr);
        //ptr += 4;
      //}
      //return vertices;
    }

    public function getVertexIndices():Vector.<int> {
      var len:int = getVertexCount();
      var ptr:int = libtess2.getVertexIndices();
      return CModule.readIntVector(ptr, len);
    }

    public function getElementCount():int {
      return libtess2.getElementCount();
    }

    public function getElements():Vector.<int> {
      var len:int = getElementCount() * _polySize;
      var ptr:int = libtess2.getElements();
      return CModule.readIntVector(ptr, len);
    }
  }
}
