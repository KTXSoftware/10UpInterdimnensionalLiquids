package;

import kha2d.Direction;
import kha.Loader;
import kha.math.Vector2;
import kha.Rectangle;
import kha2d.Sprite;

class Gas extends Sprite {
	public function new(x: Float, y: Float, speedx: Float, speedy: Float) {
		super(Loader.the.getImage('gas'));
		this.x = x;
		this.y = y;
		this.speedx = speedx;
		this.speedy = speedy;
		accy = -0.1;
		collider = new Rectangle(20, 20, 16, 16);
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
			dir.y += 0.0001;
			dir.length = 0.25;
			speedx = dir.x;
			speedy = dir.y;
		}
	}
}