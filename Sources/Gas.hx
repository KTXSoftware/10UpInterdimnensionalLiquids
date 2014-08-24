package;

import kha.Loader;
import kha.math.Vector2;
import kha.Sprite;

class Gas extends Sprite {
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage('gas'));
		this.x = x;
		this.y = y;
		accy = -0.1;
	}
	
	override public function update(): Void {
		super.update();
		if (speedy < -2) speedy = -2;
		if (speedx < 0) {
			speedx += 0.005;
			if (speedx > 0) speedx = 0;
		}
		else if (speedx > 0) {
			speedx -= 0.005;
			if (speedx < 0) speedx = 0;
		}
	}
	
	override public function hit(sprite: Sprite): Void {
		super.hit(sprite);
		if (Std.is(sprite, Gas)) {
			var pos2 = new Vector2(sprite.x, sprite.y);
			var pos1 = new Vector2(x, y);
			var dir = pos1.sub(pos2);
			dir.length = 0.1;
			speedx = dir.x * 2;
			speedy += dir.y / 2;
		}
	}
}