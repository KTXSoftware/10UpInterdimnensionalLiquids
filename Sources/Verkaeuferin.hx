package;

import kha.Animation;
import kha.Color;
import kha.graphics2.Graphics;
import kha.Loader;
import kha.math.Vector2;
import kha.Rectangle;
import kha.Scene;

class Verkaeuferin extends Player {
	private static var me: Verkaeuferin;
	
	public static function the(): Verkaeuferin {
		return me;
	}
	
	public function new(x: Float, y: Float) {
		super(x, y - 8, "mechanic", Std.int(410 / 10) * 2, Std.int(455 / 7) * 2);
		me = this;
		Player.setPlayer(2, this);
		collider = new Rectangle(20, 30, 41 * 2 - 40, (65 - 1) * 2 - 30);
		walkLeft = Animation.createRange(11, 18, 4);
		walkRight = Animation.createRange(1, 8, 4);
		standLeft = Animation.create(10);
		standRight = Animation.create(0);
		jumpLeft = Animation.create(12);
		jumpRight = Animation.create(2);
	}
}
