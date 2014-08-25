package;

import dialogue.Action;
import dialogue.EndGame;
import kha.Animation;
import kha.Color;
import kha.graphics2.Graphics;
import kha.Loader;
import kha.math.Vector2;
import kha.Rectangle;
import kha.Scene;
import kha.Scheduler;
import kha.Sprite;

class ZeroEightFifteenMan extends Player {
	private static var me: ZeroEightFifteenMan;
	
	public static function the(): ZeroEightFifteenMan {
		return me;
	}
	
	public function new(x: Float, y: Float) {
		super(x, y - 8, "nullachtfuenfzehnmann", Std.int(360 * 2 / 9), Std.int(128 * 2 / 2));
		me = this;
		Player.setPlayer(1, this);
				
		collider = new Rectangle(10 * 2, 15 * 2, (41 - 20) * 2, ((65 - 1) - 15) * 2);
		walkLeft = Animation.createRange(10, 17, 4);
		walkRight = Animation.createRange(1, 8, 4);
		standLeft = Animation.create(9);
		standRight = Animation.create(0);
		jumpLeft = Animation.create(11);
		jumpRight = Animation.create(2);
	}
	
	override public function update():Void {
		if (health <= 0) return;
		super.update();
		
		if (disableActions || Player.current() != this) return;
		
		if (x > Cfg.mannPositions[0].x + 300) {
			doEnde = true;
		} else if (x < Cfg.mannPositions[0].x + 75 && doEnde) {
			doEnde = false;
			Dialogues.setMannEndeDlg();
		}
		
		if (doGulli && y > 515) {
			doGulli = false;
			Scheduler.addTimeTask(Dialogues.setGameEnd, 1);
		}
	}
	
	public var disableActions = true;
	var doGulli = true;
	var doEnde = false;
	var doCent = true;
	var doTheke = true;
	override public function hit(sprite:Sprite):Void 
	{
		super.hit(sprite);
		
		if (Std.is(sprite, Bratpfanne) || Std.is(sprite, Shot)) {
			die();
			Action.finishThrow = true;
			Dialogue.next();
			if (Std.is(sprite, Bratpfanne)) {
				sprite.speedx = 0;
			}
		}
		
		if (disableActions || Player.current() != this) return;
		
		if (doCent) {
			if (sprite == Cfg.cent) {
				doCent = false;
				Dialogues.setGeldGefundenMannDlg();
			}
		}
		if (doTheke) {
			if (sprite == Cfg.theke) {
				doTheke = false;
				Dialogues.setVerkaufMannDlg();
			}
		}
	}
	
	private function die(): Void {
		if (health > 0) {
			health = 0;
			if (lookRight) angle = Math.PI * 1.5;
			else angle = Math.PI * 0.5;
			originX = collider.width / 2;
			originY = collider.height;
			speedx = 0;
			if (Player.current() == this) {
				Scheduler.addTimeTask(Dialogues.setGameEnd, 1);
			}
		}
	}
}
