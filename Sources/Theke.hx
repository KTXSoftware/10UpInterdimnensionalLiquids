package;

import kha.Assets;
import kha2d.Animation;
import kha2d.Sprite;
import kha2d.Rectangle;

class Theke extends Sprite {
	public function new(x: Float, y: Float) {
		var i = Assets.images.theke;
		super(i, Std.int(i.width / 2));
		this.x = x - 0.3 * width;
		this.y = y;
		//collider = new Rectangle( -20, -20, 64 * 2 + 40, 33 * 2 + 20);
	}
	
	public function besetzt() {
		setAnimation(Animation.create(1));
	}
	public function frei() {
		setAnimation(Animation.create(0));
	}
}