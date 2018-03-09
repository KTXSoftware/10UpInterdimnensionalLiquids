package;

import kha.Assets;
import kha2d.Animation;
import kha2d.Sprite;

class Door extends Sprite {
	private var backdoor: Bool;
	private var isopen = false;
	
	public function new(x: Float, y: Float, backdoor: Bool) {
		super(Assets.images.door, Std.int(128 * 2 / 4), 64 * 2, 0);
		this.x = x;
		this.y = y;
		this.backdoor = backdoor;
		collides = false;
		accy = 0;
	}
	
	override public function hit(sprite: Sprite): Void {
		super.hit(sprite);
		if (isopen) return;
		if (Std.is(sprite, Water) || Std.is(sprite, Lava) || Std.is(sprite, Gas) || Std.is(sprite, Portal)) {
			sprite.speedx *= -1;
		}
		else if (Std.is(sprite, Player)) {
			open();
		}
	}
	
	public function open(noShooting = false) {
		isopen = true;
		setAnimation(Animation.create(1));
		if (backdoor && !noShooting) Mafioso.the().useMg = true;
	}
}
