package;

import kha.Assets;
import kha.graphics2.Graphics;
import kha.Image;
import kha2d.Sprite;

class Broetchen extends Sprite {
	public function new(mehrkorn = false) {
		if (mehrkorn) {
			super(Assets.images.broetchen2);
		}
		else {
			super(Assets.images.broetchen1);
		}
		this.speedx = 4;
		accy = 0;
	}
}
