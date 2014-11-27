package
{
	import com.codeazur.libtess2.Tesselator;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.globalization.NumberFormatter;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	public class StressTestSpriteFloat extends Sprite
	{
		private var t:Tesselator;
		private var tf:TextField;
		private var nf:NumberFormatter;
		private var count:int;
		private var avgTotal:Number = 0;
		
		public function StressTestSpriteFloat()
		{
			nf = new NumberFormatter("en_US");
			nf.fractionalDigits = 2;
			
			tf = new TextField();
			tf.autoSize = "left";
			tf.defaultTextFormat = new TextFormat(null, 25);
			addChild(tf);
			
			t = new Tesselator();
			t.initBuffer(1024 * 1024);
			
			if (stage == null)
				addEventListener(Event.ADDED_TO_STAGE, init);
			else
				init();
		}
		
		public function destroy():void
		{
			t.destroyBuffer();
			removeEventListener(Event.ADDED_TO_STAGE, init);
			removeEventListener(Event.ENTER_FRAME, doStuff);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.ENTER_FRAME, doStuff);
		}
		
		private function doStuff(e:Event):void
		{
			tf.text = "float version\n" + nf.formatNumber(System.privateMemory / 1024 / 1024) + " mb memory total\n\n";
			
			var time0:int = getTimer();
			
			var path1:Vector.<Number> = createCircle(new Point(300, 300), 250, 50, 250);
			var path2:Vector.<Number> = createCircle(new Point(300, 300), 190, 50, 150);
			var path3:Vector.<Number> = createCircle(new Point(300, 300), 130, 50, 100);
			var path4:Vector.<Number> = createCircle(new Point(300, 300), 50, 50, 100);
			
			tf.appendText((getTimer() - time0) + " ms contour creation\n");
			
			var time1:int = getTimer();
			
			t.newTess();
			t.addContour(path1, path1.length / 2, 2);
			t.addContour(path2, path2.length / 2, 2);
			t.addContour(path3, path3.length / 2, 2);
			t.addContour(path4, path4.length / 2, 2);
			
			tf.appendText((getTimer() - time1) + " ms preparation\n");
			
			time1 = getTimer();
			
			t.tesselate(Tesselator.WINDING_ODD, Tesselator.ELEMENT_TYPE_POLYGONS, 3, 2);
			
			tf.appendText((getTimer() - time1) + " ms tesselation\n");
			
			time1 = getTimer();
			
			var vertices:Vector.<Number> = t.getVertices();
			var vertexCount:int = t.getVertexCount();
			var elements:Vector.<int> = t.getElements();
			var elementCount:int = t.getElementCount();
			
			tf.appendText((getTimer() - time1) + " ms results retrieval\n");
			
			var total:int = getTimer() - time0;
			avgTotal = avgTotal * 0.5 + total * 0.5;
			tf.appendText("------\n" + total.toString() + " ms total " + "(" + nf.formatNumber(avgTotal).toString() + " avg)");
			
			graphics.clear();
			graphics.lineStyle(1, 0x008800);
			for (var i:int; i < elementCount; i++)
			{
				var v1x:Number = vertices[elements[i * 3] * 2];
				var v1y:Number = vertices[elements[i * 3] * 2 + 1];
				var v2x:Number = vertices[elements[i * 3 + 1] * 2];
				var v2y:Number = vertices[elements[i * 3 + 1] * 2 + 1];
				var v3x:Number = vertices[elements[i * 3 + 2] * 2];
				var v3y:Number = vertices[elements[i * 3 + 2] * 2 + 1];
				graphics.beginFill(0x00cc00, 0.5);
				graphics.moveTo(v1x, v1y);
				graphics.lineTo(v2x, v2y);
				graphics.lineTo(v3x, v3y);
				graphics.endFill();
			}
		
		}
		
		private function createCircle(center:Point, radius:Number, noise:Number, count:uint, clockwise:Boolean = true):Vector.<Number>
		{
			var vertices:Vector.<Number> = new Vector.<Number>();
			var p:Point;
			var angle:Number = 0;
			var delta:Number = 2 * Math.PI / count;
			for (var i:uint = 0; i < count; i++)
			{
				p = Point.polar(radius + Math.random() * noise, angle).add(center);
				vertices.push(p.x, p.y);
				angle += clockwise ? delta : -delta;
			}
			return vertices;
		}
	
	}
}
