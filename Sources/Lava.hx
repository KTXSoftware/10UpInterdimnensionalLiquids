package;

import kha.Animation;
import kha.Direction;
import kha.Loader;
import kha.math.Vector2i;
import kha.Sprite;

class Lava extends Sprite {
	private var lastTile: Vector2i;
	private var right: Animation;
	private var left: Animation;
	
	public function new(x: Float, y: Float, speedx: Float, speedy: Float) {
		super(Loader.the.getImage("lava"), 32, 32);
		this.x = x;
		this.y = y;
		this.speedx = speedx;
		this.speedy = speedy;
		left = Animation.create(0);
		right = Animation.create(1);
		if (speedx > 0) setAnimation(right);
		else setAnimation(left);
	}
	
	override public function update(): Void {
		super.update();
		splash();
	}
	
	private function isLava(value: Int): Bool {
		return value > 19 && value < 36;
	}
	
	private function isWallOrLava(value: Int): Bool {
		return value == 0 || isLava(value);
	}
	
	private function splash(): Void {
		var tile = Level.liquids.index(x, y + height - 1);
		var value = Level.liquids.get(tile.x, tile.y);
		var valueBelow = Level.liquids.get(tile.x, tile.y + 1);
	
		var map = Level.tilemap.get(tile.x, tile.y);
		var mapBelow = Level.tilemap.get(tile.x, tile.y + 1);
		if (map == 346 || map == 347) {
			Level.tilemap.set(tile.x, tile.y, map - 2);
			Level.liquids.set(tile.x, tile.y, 1);
			return;
		}
		if (mapBelow == 346 || mapBelow == 347) {
			Level.tilemap.set(tile.x, tile.y + 1, mapBelow - 2);
			Level.liquids.set(tile.x, tile.y + 1, 1);
			return;
		}
		var floored = isWallOrLava(value) || isWallOrLava(valueBelow);		
		if (lastTile == null || tile.x != lastTile.x) {
			lastTile = tile;
			if (floored) {
				if (isLava(valueBelow) && valueBelow < 35) Level.liquids.set(tile.x, tile.y + 1, valueBelow == 1 ? 20 : valueBelow + 1);
				else if (value == 1 || value > 19 && value < 35) Level.liquids.set(tile.x, tile.y, value == 1 ? 20 : value + 1);
			}
		}
	}
	
	override public function hitFrom(dir: Direction): Void {
		super.hitFrom(dir);
		if (dir == Direction.LEFT || dir == Direction.RIGHT) {
			speedx = -speedx;
			
			if (speedx < 0) setAnimation(left);
			else setAnimation(right);
			
			splash();
			lastTile = null;
		}
	}
}
