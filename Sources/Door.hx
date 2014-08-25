package;

import kha.Animation;
import kha.Loader;
import kha.Sprite;

class Door extends Sprite {
	private var backdoor: Bool;
	
	public function new(x: Float, y: Float, backdoor: Bool) {
		super(Loader.the.getImage('door'), Std.int(128 * 2 / 4), 64 * 2, 0);
		this.x = x;
		this.y = y;
		this.backdoor = backdoor;
	}
	
	override public function hit(sprite: Sprite): Void {
		super.hit(sprite);
		open();
	}
	
	public function open() {
		setAnimation(Animation.create(1));
		if (backdoor) Mafioso.the().useMg = true;
	}
}