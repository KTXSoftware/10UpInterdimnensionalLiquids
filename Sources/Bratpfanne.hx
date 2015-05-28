package;

import kha.Loader;
import kha2d.Sprite;

class Bratpfanne extends Sprite {
	public function new() {
		super(Loader.the.getImage('Bratpfanne')); // TODO!!!
		this.speedx = 10;
		accy = 0;
	}
}
