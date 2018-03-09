package;

import kha.Assets;
import kha.graphics2.Graphics;
import kha2d.Scene;
import kha.Scheduler;
import kha2d.Sprite;

class LavaSplash extends Sprite {
	private var start: Float;
	
	public function new(x: Float, y: Float, speedx: Float, speedy: Float) {
		super(Assets.images.lavasplash, 32, 32);
		this.x = x;
		this.y = y;
		this.speedx = speedx;
		this.speedy = speedy;
		start = Scheduler.time();
	}
	
	override public function update(): Void {
		super.update();
		var alpha = Scheduler.time() - start;
		if (alpha > 1) {
			Scene.the.removeProjectile(this);
			return;
		}
	}
	
	override public function render(g: Graphics): Void {
		var alpha = Scheduler.time() - start;
		if (alpha > 1) {
			return;
		}
		g.pushOpacity(1 - alpha);
		scaleX = scaleY = 1 - alpha;
		super.render(g);
		g.popOpacity();
	}
}
