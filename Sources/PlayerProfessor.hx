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
		Player.setPlayer(1, this);
				
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
			timecannon.x -= 15;
			timecannon.angle = timecannon.angle + Math.PI;
			if (timecannon.animation.indices != timecannon.leftAnim.indices) {
				timecannon.animation.indices = timecannon.leftAnim.indices;
				timecannon.originX = timecannon.width - timecannon.originX;
			}
		}
	}
	
	override public function render(g: Graphics): Void {
		super.render(g);
		//if (isCrosshairVisible || timeCannonNextFireTime > TenUp.instance.currentGameTime + 23.5) {
			timecannon.render(g);
		//}
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
		//Scene.the.addOther(new Water(x + 10, y));
		//Scene.the.addOther(new Lava(x + 10, y));
		var dir = new Vector2(TenUp3.instance.mouseX, TenUp3.instance.mouseY).sub(new Vector2(x, y));
		dir.length = 4;
		if (lastPortal != null) {
			lastPortal.remove();
			Scene.the.removeOther(lastPortal);
		}
		Scene.the.addOther(lastPortal = new Portal(x + 10, y, dir.x, dir.y, Inventory.selectedIndex()));
	}
	
	/**
	  Hacking
	 */
	override public function useSpecialAbilityB(gameTime: Float): Void {
		/*if (Level.the.computers.length > 0) {
			var computer = Level.the.computers[0];
			if (computer.collisionRect().collision(collisionRect())) {
				Level.the.gates[0].open();
			}
		}*/
	}
	
	override public function hit(sprite: Sprite): Void {
		if (Std.is(sprite, TenUpShelf)) {
			Dialogues.startProfGotItDialog(this);
		}
	}
}
