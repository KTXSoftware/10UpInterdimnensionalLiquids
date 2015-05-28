package;

import kha.graphics2.Graphics;
import kha.Loader;
import kha2d.Scene;
import kha.Scheduler;
import kha2d.Sprite;

class Haze extends Sprite {
	private var start: Float;
	
	public function new(x: Float, y: Float) {
		super(Loader.the.getImage('haze'));
		this.x = x;
		this.y = y;
		accy = -0.1;
		start = Scheduler.time();
	}
	
	override public function update(): Void {
		super.update();
		var alpha = (Scheduler.time() - start) * 0.2;
		if (alpha > 1) {
			Scene.the.removeProjectile(this);
			return;
		}
	}
	
	override public function render(g: Graphics): Void {
		var alpha = (Scheduler.time() - start) * 0.2;
		if (alpha > 1) {
			return;
		}
		g.pushOpacity(1 - alpha);
		super.render(g);
		g.popOpacity();
	}
}
