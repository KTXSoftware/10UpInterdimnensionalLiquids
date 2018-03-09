package;

import kha.Assets;
import kha.graphics2.Graphics;
import kha.Image;
import kha2d.Scene;
import kha2d.Sprite;

class Mafioso extends Sprite {
	private var count: Int = 0;
	private var mg : Sprite;
	public var useMg : Bool;
	private var sleeping = false;
	
	private static var me: Mafioso;
	
	public static function the(): Mafioso {
		return me;
	}
	
	public function new(x: Float, y: Float) {
		super(Assets.images.boss);
		me = this;
		mg = new Sprite(Assets.images.machinegun);
		this.x = x;
		this.y = y;
	}
	
	override public function update(): Void {
		super.update();
		if (useMg) {
			++count;
			if (count % 20 == 0) {
				Scene.the.addProjectile(new Shot(x - mg.width / 2, y + height / 2 - 10, -10));
			}
		}
		if (!sleeping && PlayerProfessor.lotsOfGas()) {
			sleeping = true;
			angle = Math.PI * 0.5;
			originX = collider.width / 2;
			originY = collider.height;
		}
	}
	
	override public function render(g:Graphics):Void 
	{
		super.render(g);
		if (useMg) {
			mg.x = x - mg.width / 2;
			mg.y = y + height - mg.height;
			mg.render(g);
		}
	}
}
