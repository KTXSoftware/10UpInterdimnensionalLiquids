package;

import kha.Loader;
import kha.Scene;
import kha.Sprite;

class Mafioso extends Sprite {
	private var count: Int = 0;
	
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage('machinegun'));
		this.x = x;
		this.y = y;
	}
	
	override public function update(): Void {
		super.update();
		++count;
		if (count % 20 == 0) {
			Scene.the.addProjectile(new Shot(x, y + height / 2 - 6, -10));
		}
	}
}
