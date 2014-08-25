package;

import kha.Image;
import kha.Loader;
import kha.Sprite;

class Broetchen extends Sprite {
	public function new() {
		super(Loader.the.getImage('broetchen1')); // TODO!!!
		this.speedx = 4;
		accy = 0;
	}
	
	override public function update():Void {
		super.update();
		
		if (Cfg.getVictoryCondition(VictoryCondition.MEHRKORN)) {
			image = Loader.the.getImage("broetchen1");
		} else {
			image = Loader.the.getImage("broetchen2");
		}
	}
}
