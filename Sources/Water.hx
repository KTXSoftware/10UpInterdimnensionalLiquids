package;

import kha.Animation;
import kha.Direction;
import kha.Loader;
import kha.math.Vector2i;
import kha.Sprite;

class Water extends Sprite {
	private var lastTile: Vector2i;
	private var floored: Bool = false;
	private var right: Animation;
	private var left: Animation;
	
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage("water"), 16, 16);
		this.x = x;
		this.y = y;
		speedx = 4;
		left = Animation.create(0);
		right = Animation.create(1);
		setAnimation(right);
		//accy = 0.2;
	}
	
	override public function update(): Void {
		super.update();
		splash();
	}
	
	private function splash(): Void {
		var tile = Level.liquids.index(x, y + height - 1);
		var value = Level.liquids.get(tile.x, tile.y);
		/*if (value == 0 && !floored) accy = 0.2;
		else {
			accy = 0;
			y = tile.y * 16 - value * 2 + 1;
		}*/
		//if (value > 0 && tile.y * 16 - value * 2 < y) {
		//	accy = -0.1;
		//	floored = true;
		//}
		//else accy = 0.2;
		if (lastTile == null || tile.x != lastTile.x || tile.y != lastTile.y) {
			lastTile = tile;
			if (floored) {
				if (value > 0 && value < 9) Level.liquids.set(tile.x, tile.y, value + 1);
			}
		}
		floored = false;
	}
	
	override public function hitFrom(dir: Direction): Void {
		super.hitFrom(dir);
		if (dir == Direction.UP) floored = true;
		if (dir == Direction.LEFT || dir == Direction.RIGHT) {
			speedx = -speedx;
			
			if (speedx < 0) setAnimation(left);
			else setAnimation(right);
			
			/*var tile = Level.liquids.index(x, y + height - 1);
			var value = Level.liquids.get(tile.x, tile.y);
			//if (value > 0 && tile.y * 16 - value * 2 < y) {
			//	floored = true;
			//}
			lastTile = tile;
			if (floored || value > 0) {
				if (value < 8) Level.liquids.set(tile.x, tile.y, value + 1);
			}*/
			lastTile = null;
		}
	}
}
