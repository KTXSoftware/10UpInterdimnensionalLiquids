package;

import kha.graphics2.Graphics;
import kha.Image;
import kha.Loader;
import kha.Sprite;

class Broetchen extends Sprite {
	public function new() {
		super(Loader.the.getImage('broetchen1'));
		this.speedx = 4;
		accy = 0;
	}
	
	override public function render(g:Graphics):Void 
	{
		if (Cfg.getVictoryCondition(VictoryCondition.MEHRKORN)) {
			image = Loader.the.getImage("broetchen1");
		} else {
			image = Loader.the.getImage("broetchen2");
		}
		super.render(g);
	}
}
