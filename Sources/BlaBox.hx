package;

import kha.AnimatedImageCursor;
import kha.Color;
import kha.Font;
import kha.FontStyle;
import kha.Loader;
import kha.graphics2.Graphics;
import kha.Scene;
import kha.Sprite;

class BlaBox {
	private static var pointed: Sprite;
	private static var font: Font;
	private static var text: String = null;
	
	public static function pointAt(sprite: Sprite): Void {
		pointed = sprite;
	}
	
	public static function setText(text: String): Void {
		if (text != null) {
			BlaBox.text = Localization.getText(text);
		} else {
			BlaBox.text = null;
		}
	}
	
	public static function render(g: Graphics): Void {
		if (text == null) return;
		
		if (font == null) font = Loader.the.loadFont("Liberation Sans", new FontStyle(false, false, false), 20);
		
		var sx : Float = -1;
		var sy : Float = -1;
		if (pointed != null) {
			sx = pointed.x + pointed.width / 2 - Scene.the.screenOffsetX;
			sy = pointed.y - 30 - Scene.the.screenOffsetY;
		}
		
		var right: Bool;
		var top: Bool;
		
		var width = 400;
		
		right = !(sx < width);
		
		var x : Float = (pointed == null) ? (0.5 * (kha.Game.the.width - width)) : 50;
		if (right) {
			 x = kha.Game.the.width - width - 50;
		}
		
		var width = 400;
		var height = 150;
		
		var y : Float = 50;
		if (pointed != null) {
			if (y + height + 50 > sy) {
				y -= Math.max(45, y + height + 50 - sy);
			}
			if (y < 0) {
				y = 0;
			}
		}
		
		
		g.color = Color.White;
		g.fillRect(x, y, width, height);
		g.color = Color.Black;
		g.drawRect(x, y, width, height, 5);
		g.color = Color.White;
		if (pointed != null) {
			g.fillTriangle(sx - 10, y + height - 5, sx + 10, y + height - 5, sx, sy);
			g.color = Color.Black;
			g.drawLine(sx - 10, y + height -5, sx, sy, 3);
			g.drawLine(sx + 10, y + height -5, sx, sy, 3);
		} else {
			g.color = Color.Black;
		}
		g.font = font;
		
		var tx: Float = x + 10;
		var ty: Float = y + 10;
		var t = 0;
		var word = "";
		var first = true;
		while (t < text.length + 1) {
			var char = text.charAt(t);
			if (text.length == t || char == " " || char == "\n") {
				var txnext: Float = 0;
				if (first) txnext = tx + font.stringWidth(word);
				txnext = tx + font.stringWidth(" ") + font.stringWidth(word);
				if (txnext > x + width - 20) {
					tx = x + 10;
					ty += font.getHeight();
					g.drawString(word, tx, ty);
					tx = tx + font.stringWidth(word);
				}
				else {
					if (first) g.drawString(word, tx, ty);
					else g.drawString(" " + word, tx, ty);
					tx = txnext;
				}
				if (char == "\n") {
					first = true;
					tx = x + 10;
					ty += font.getHeight();
				} else {
					first = false;
				}
				word = "";
			}
			else {
				word += text.charAt(t);
			}
			++t;
		}
	}
}
