package;

import kha.Assets;
import kha2d.Animation;
import kha2d.Sprite;

class TenUpShelf extends Sprite {
	public function new(x: Float, y: Float) {
		super(Assets.images._10up, 94, 33 * 2);
		this.x = x;
		this.y = y;
		accy = 0;
		collides = false;
		setAnimation(Animation.create(0));
	}	
}
