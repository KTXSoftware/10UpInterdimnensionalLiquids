package;

import kha.Image;
import kha2d.Rectangle;

class LiquidTile extends kha2d.Tile {
	private var lines: Array<Int>;
	
	public function new(imageIndex: Int) {
		super(imageIndex, true);
		lines = new Array<Int>();
		for (y in 0...32) {
			lines.push(0);
			for (x in 0...32) {
				lines[y] <<= 1;
				if (imageIndex == 0) lines[y] |= 1;
				else if (Water.isWater(imageIndex) && y >= 32 - ((imageIndex - 1) * 2)) lines[y] |= 1;
				else if (Lava.isLava(imageIndex) && y >= 32 - ((imageIndex - 19) * 2)) lines[y] |= 1;
				else if (y >= 32 - ((imageIndex - (19 + 18)) * 2)) lines[y] |= 1;
			}
		}
	}
	
	static function bits(from: Int, to: Int, value: Int): Int {
		return value << from >>> (31 - to + from);
	}
	
	override public function collision(rect: Rectangle): Bool {
		if (collides) {
			var xstart = Std.int(Math.round(Math.max(0.0, rect.x - 1)));
			var xend   = Std.int(Math.round(Math.min(31.0, rect.x + rect.width - 1)));
			var ystart = Std.int(Math.round(Math.max(0.0, rect.y - 1)));
			var yend   = Std.int(Math.round(Math.min(31.0, rect.y + rect.height - 1)));
			if (xend < xstart) return false;
			for (y in ystart...yend + 1) {
				if (bits(xstart, xend, lines[y]) != 0) return true;
			}
			return false;
		}
		else return false;
	}
}
