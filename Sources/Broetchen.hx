package;

import kha.graphics2.Graphics;
import kha.Image;
import kha.Loader;
import kha2d.Sprite;

class Broetchen extends Sprite {
	public function new(mehrkorn = false) {
		if (mehrkorn) {
			super(Loader.the.getImage('broetchen2'));
		} else {
			super(Loader.the.getImage('broetchen1'));
		}
		this.speedx = 4;
		accy = 0;
	}
}
