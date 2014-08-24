package;

import kha.Loader;
import kha.Sprite;

class TenUpShelf extends Sprite {
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage('10up'));
		this.x = x;
		this.y = y;
		accy = 0;
	}	
}
