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
		if (pointed == null || text == null) return;
		if (font == null) font = Loader.the.loadFont("Liberation Sans", new FontStyle(false, false, false), 20);
		
		var sx = pointed.x + pointed.width / 2 - Scene.the.screenOffsetX;
		var sy = pointed.y - 10;
		
		var left: Bool;
		var top: Bool;
		
		if (sx < 400) {
			left = true;
		}
		else {
			left = false;
		}
		
		var x: Float = 370;
		if (left) {
			x = 30;
		}
		
		var y = 150;
		var width = 400;
		var height = 100;
		
		g.color = Color.White;
		g.fillRect(x, y, width, height);
		g.color = Color.Black;
		g.drawRect(x, y, width, height, 5);
		g.color = Color.White;
		g.fillTriangle(sx - 10, y + height - 5, sx + 10, y + height - 5, sx, sy);
		g.color = Color.Black;
		g.drawLine(sx - 10, y + height -5, sx, sy, 5);
		g.drawLine(sx + 10, y + height -5, sx, sy, 5);
		g.font = font;
		
		var tx: Float = x + 10;
		var ty: Float = y + 10;
		var t = 0;
		var word = "";
		var first = true;
		while (t < text.length + 1) {
			if (text.length == t || text.charAt(t) == " ") {
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
				first = false;
				word = "";
			}
			else {
				word += text.charAt(t);
			}
			++t;
		}
	}
}
