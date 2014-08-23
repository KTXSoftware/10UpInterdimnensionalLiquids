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
		if (font == null) font = Loader.the.loadFont("Liberation Sans", new FontStyle(false, false, false), 14);
		
		var sx = pointed.x + pointed.width / 2 - Scene.the.screenOffsetX;
		var sy = pointed.y - Scene.the.screenOffsetY - 15;
		
		var left: Bool;
		var top: Bool;
		
		if (sx < 200) {
			left = true;
		}
		else {
			left = false;
		}
		
		var x: Float = 160;
		if (left) {
			x = 10;
		}
		
		var y = 75;
		var width = 250;
		var height = 80;
		
		g.color = Color.White;
		g.fillRect(x, y, width, height);
		g.color = Color.Black;
		g.drawRect(x, y, width, height, 2);
		g.color = Color.White;
		g.fillTriangle(sx - 2, y + height - 1, sx + 2, y + height - 1, sx, sy);
		g.color = Color.Black;
		g.drawLine(sx - 2, y + height - 2, sx, sy, 2);
		g.drawLine(sx + 2, y + height - 2, sx, sy, 2);
		g.font = font;
		
		var tx: Float = x + 5;
		var ty: Float = y + 5;
		var t = 0;
		var word = "";
		var first = true;
		while (t < text.length + 1) {
			if (text.length == t || text.charAt(t) == " ") {
				var txnext: Float = 0;
				if (first) txnext = tx + font.stringWidth(word);
				txnext = tx + font.stringWidth(" ") + font.stringWidth(word);
				if (txnext > x + width - 10) {
					tx = x + 5;
					ty += font.getHeight();
					g.drawString(word, tx, ty);
					tx = tx + font.stringWidth(word);
				}
				else {
					if (first) g.drawString(word, tx, ty);
					else g.drawString(" " + word, tx, ty);
					tx = txnext;
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
