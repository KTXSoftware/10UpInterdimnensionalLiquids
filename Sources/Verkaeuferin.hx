package;

import kha.Animation;
import kha.Color;
import kha.graphics2.Graphics;
import kha.Loader;
import kha.math.Vector2;
import kha.Rectangle;
import kha.Scene;
import kha.Scheduler;
import kha.Sprite;

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
	
	public var disableActions = true;
	var doGulli = true;
	var dropCent = true;
	var doTheke = true;
	override public function update():Void {
		if (health <= 0) return;
		super.update();
		
		if (disableActions || Player.current() != this) return;
		
		if (dropCent && x > Cfg.verkaeuferinPositions[0].x + 150) {
			dropCent = false;
			Dialogues.setGeldVerlohrenVerkDlg();
		}
		
		if (doGulli && y > 515) {
			doGulli = false;
			kha.Scheduler.addTimeTask(Dialogues.setGameEnd, 1);
		}
		
		if (left && x + 50 < Cfg.verkaeuferinPositions[0].x) {
			Dialogues.setWrongDirection();
		}
	}
	
	override public function hit(sprite:Sprite):Void 
	{
		super.hit(sprite);
		
		if (Std.is(sprite, Bratpfanne) || Std.is(sprite, Shot)) {
			die();
			if (Std.is(sprite, Bratpfanne)) {
				sprite.speedx = 0;
			}
		}
		
		if (disableActions || Player.current() != this) return;
		
		if (doTheke) {
			if (sprite == Cfg.theke) {
				doTheke = false;
				Dialogues.setVerkaufStartDlg();
			}
		}
	}
	
	private function die(): Void {
		if (health > 0) {
			health = 0;
			if (lookRight) setAnimation(Animation.create(22));
			else setAnimation(Animation.create(23));
			speedx = 0;
			if (Player.current() == this) {
				Scheduler.addTimeTask(Dialogues.setGameEnd, 1);
			}
		}
	}
}
