package;

import kha.Loader;
import kha.Sprite;

class Broetchen extends Sprite {
	public function new() {
		super(Loader.the.getImage('mechanic')); // TODO!!!
		this.speedx = 4;
		accy = 0;
	}
}