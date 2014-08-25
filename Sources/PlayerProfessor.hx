package;

import kha.Animation;
import kha.Color;
import kha.graphics2.Graphics;
import kha.Loader;
import kha.math.Vector2;
import kha.Rectangle;
import kha.Scene;
import kha.Sprite;

class PlayerProfessor extends Player {
	var timecannon : TimeCannon;
	
	public function new(x: Float, y: Float) {
		super(x, y - 8, "professor", Std.int(410 / 10 * 2), Std.int(455 / 7 * 2));
		Player.setPlayer(0, this);
		
		collider = new Rectangle(10 * 2, 15 * 2, (41 - 20) * 2, ((65 - 1) - 15) * 2);
		walkLeft = Animation.createRange(11, 18, 4);
		walkRight = Animation.createRange(1, 8, 4);
		standLeft = Animation.create(10);
		standRight = Animation.create(0);
		jumpLeft = Animation.create(16);
		jumpRight = Animation.create(6);
		
		timecannon = new TimeCannon();
	}
	
	override public function leftButton(): String {
		return "Shoot";
	}
	
	override public function rightButton(): String {
		return "Hack";
	}
	
	@:access(kha.Animation) 
	override public function update() {
		if (gameover) return;
		super.update();
		timecannon.update();
		var c = center;
		timecannon.x = c.x - 0.25 * timecannon.width;
		//graple.x = x + 10;
		timecannon.y = c.y - 0.25 * timecannon.height - 3;
		timecannon.angle = Math.atan2(crosshair.y, crosshair.x);
		if (lookRight) {
			timecannon.x += 15;
			if (timecannon.animation.indices != timecannon.rightAnim.indices) {
				timecannon.animation.indices = timecannon.rightAnim.indices;
				timecannon.originX = timecannon.width - timecannon.originX;
			}
		} else {
			timecannon.x -= 60;
			timecannon.angle = timecannon.angle + Math.PI;
			if (timecannon.animation.indices != timecannon.leftAnim.indices) {
				timecannon.animation.indices = timecannon.leftAnim.indices;
				timecannon.originX = timecannon.width - timecannon.originX;
			}
		}
		
		if (foundTenUp && x < 300 && !finishedGame) {
			win();
		}
		
		var tile = Level.liquids.index(x + collider.width / 2, y + collider.height);
		if (!gameover && Lava.isLava(Level.liquids.get(tile.x, tile.y))) {
			die();
		}
		
		if (!visitedVeraeuferin && x > 1900) {
			visitedVeraeuferin = true;
			if (Cfg.getVictoryCondition(VictoryCondition.PLAYED_VERKAEUFERIN) && Cfg.verkaeuferin.health > 0) {
				if (!Cfg.getVictoryCondition(VictoryCondition.MATHEGENIE)) Dialogues.setGefeuertProfDlg();
			}
		}
	}
	
	override public function render(g: Graphics): Void {
		timecannon.render(g);
		super.render(g);
	}
	
	/**
	  Time Cannon
	**/
	var timeCannonNextFireTime : Float = 0;
	override public function prepareSpecialAbilityA(gameTime:Float) : Void {
		isCrosshairVisible = true;
	}
	
	private var lastPortal: Portal;
	
	override public function useSpecialAbilityA() : Void {
		if (gameover) return;
		Cfg.setVictoryCondition(VictoryCondition.WATER, false);
		var dir = new Vector2(TenUp3.instance.mouseX - 16, TenUp3.instance.mouseY - 16).sub(new Vector2(x, y));
		dir.length = 8;
		if (lastPortal != null) {
			lastPortal.remove();
			Scene.the.removeOther(lastPortal);
			lastPortal = null;
		}
		if (inventory.selectedIndex() != 3) {
			if ((lookRight && TenUp3.instance.mouseX - 16 > x) || (!lookRight && TenUp3.instance.mouseX - 16 < x)) {
				Scene.the.addOther(lastPortal = new Portal(x + 10, y, dir.x, dir.y, inventory.selectedIndex()));
			}
		}
	}

	private var foundTenUp: Bool = false;
	private var finishedGame: Bool = false;
	private var gameover: Bool = false;
	private var visitedVeraeuferin: Bool = false;
	
	override public function hit(sprite: Sprite): Void {
		if (!foundTenUp && Std.is(sprite, TenUpShelf)) {
			Dialogues.startProfGotItDialog(this);
			foundTenUp = true;
			if (lotsOfGas()) {
				
			}
			else {
				Mafioso.the().x = 1920;
				Mafioso.the().useMg = true;
			}
			Cfg.setVictoryCondition(VictoryCondition.TENUPWEG, true);
			Cfg.setVictoryCondition(VictoryCondition.PLAYED_PROFESSOR, true);
			Cfg.setMap(Level.getSaveMap());
			Cfg.save();
		}
		else if (!gameover && Std.is(sprite, Shot)) {
			die();
		}
	}
	
	private function lotsOfGas(): Bool {
		var gas: Int = 0;
		for (i in 0...Scene.the.countOthers()) {
			var other = Scene.the.getOther(i);
			if (Std.is(other, Gas) && other.x > 1950 && other.y < 500) {
				++gas;
			}
		}
		return gas > 30;
	}
	
	private function win(): Void {
		Dialogues.startProfWinDialog(this);
		finishedGame = true;
		Cfg.setMap(Level.getSaveMap());
		Cfg.setVictoryCondition(VictoryCondition.PLAYED_PROFESSOR, true);
		Cfg.setVictoryCondition(VictoryCondition.SLEEPY, lotsOfGas());
		Cfg.save();
	}
	
	private function die(): Void {
		Dialogues.startProfLooseDialog(this);
		gameover = true;
		if (lookRight) setAnimation(Animation.create(22));
		else setAnimation(Animation.create(23));
		speedx = 0;
		Cfg.setMap(Level.getSaveMap());
		Cfg.setProfPosition(x, y);
		Cfg.setVictoryCondition(VictoryCondition.PLAYED_PROFESSOR, true);
		Cfg.setVictoryCondition(VictoryCondition.SLEEPY, lotsOfGas());
		Cfg.save();
	}
}
