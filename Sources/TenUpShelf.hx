package;

import kha.Animation;
import kha.Loader;
import kha.Sprite;

class TenUpShelf extends Sprite {
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage('10up'), 94, 33 * 2);
		this.x = x;
		this.y = y;
		accy = 0;
		collides = false;
		setAnimation(Animation.create(0));
	}	
}
