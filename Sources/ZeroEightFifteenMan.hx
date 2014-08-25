package;

import kha.Animation;
import kha.Color;
import kha.graphics2.Graphics;
import kha.Loader;
import kha.math.Vector2;
import kha.Rectangle;
import kha.Scene;
import kha.Sprite;

class ZeroEightFifteenMan extends Player {
	private static var me: ZeroEightFifteenMan;
	
	public static function the(): ZeroEightFifteenMan {
		return me;
	}
	
	public function new(x: Float, y: Float) {
		super(x, y - 8, "professor", Std.int(410 / 10 * 2), Std.int(455 / 7 * 2));
		me = this;
		Player.setPlayer(1, this);
				
		collider = new Rectangle(10 * 2, 15 * 2, (41 - 20) * 2, ((65 - 1) - 15) * 2);
		walkLeft = Animation.createRange(11, 18, 4);
		walkRight = Animation.createRange(1, 8, 4);
		standLeft = Animation.create(10);
		standRight = Animation.create(0);
		jumpLeft = Animation.create(16);
		jumpRight = Animation.create(6);
	}
	
	override public function hit(sprite:Sprite):Void 
	{
		super.hit(sprite);
		if (sprite == Cfg.cent) {
			Dialogues.setGeldGefundenMannDlg();
		}
	}
}
