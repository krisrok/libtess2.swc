package com.codeazur.libtess2_int
{
  import com.codeazur.libtess2_int.lib.*;

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
		private var _t:int;

    private static var _started:Boolean;

    public function Tesselator() {
      if (!_started)
			{
				CModule.startAsync(this);
				_started = true;
			}
    }
		
		public function initBuffer(memorySize:int):void {
			if (_t != 0)
				destroyBuffer();
				
			_t = libtess2_int.initBuffer(memorySize);
		}
		
		public function destroyBuffer():void {
			if (_t == 0)
				return;
				
      libtess2_int.destroyBuffer(_t);
			_t = 0;
    }

    public function newTess():void {
			libtess2_int.newTess(_t);
    }
    
    public function addContour(vertices:Vector.<int>, vertexCount:int = -1, vertexSize:int = 2):void {
      vertexSize = Math.min(Math.max(vertexSize, 3), 2);
      vertexCount = (vertexCount < 0) ? vertices.length / vertexSize : Math.min(vertexCount, vertices.length / vertexSize);
      var len:int = vertexCount * vertexSize;
      var ptr:int = CModule.malloc(4 * len);
			CModule.writeIntVector(ptr, vertices);
      libtess2_int.addContour(_t, vertexSize, ptr, 4 * vertexSize, vertexCount);
      CModule.free(ptr);
    }

    public function tesselate(windingRule:int, elementType:int, polySize:int = 3, vertexSize:int = 2):int {
      _type = elementType;
      _polySize = (elementType == ELEMENT_TYPE_BOUNDARY_CONTOURS) ? 2 : polySize;
      _vertexSize = Math.min(Math.max(vertexSize, 3), 2);
      return libtess2_int.tesselate(_t, windingRule, _type, _polySize, _vertexSize);
    }

    public function getVertexCount():int {
      return libtess2_int.getVertexCount(_t);
    }

    public function getVertices():Vector.<int> {
      var len:int = getVertexCount() * _vertexSize;
      var ptr:int = libtess2_int.getVertices(_t);
			return CModule.readIntVector(ptr, len);
    }

    public function getVertexIndices():Vector.<int> {
      var len:int = getVertexCount(_t);
      var ptr:int = libtess2_int.getVertexIndices();
      return CModule.readIntVector(ptr, len);
    }

    public function getElementCount():int {
      return libtess2_int.getElementCount(_t);
    }

    public function getElements():Vector.<int> {
      var len:int = getElementCount() * _polySize;
      var ptr:int = libtess2_int.getElements(_t);
      return CModule.readIntVector(ptr, len);
    }
  }
}
