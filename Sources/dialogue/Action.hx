package dialogue;

import Dialogue.DialogueItem;
import kha.Color;
import kha.math.Vector2;
import kha.Scene;
import kha.Sprite;

enum ActionType {
	MG;
	FADE;
	THROW;
}

class Action implements DialogueItem {
	var autoAdvance : Bool = true;
	var started : Bool = false;
	var sprites : Array<Sprite>;
	var type : ActionType;
	var counter : Int = 0;
	public var finished(default, null) : Bool = false;
	public function new(sprites: Array<Sprite>, type: ActionType) {
		this.sprites = sprites;
		this.type = type;
	}
	
	@:access(Dialogue.isActionActive) 
	public function execute() : Void {
		if (!started) {
			started = true;
			counter = 0;
			switch(type) {
				case ActionType.MG:
					// TODO
				case ActionType.FADE:
					TenUp3.getInstance().renderOverlay = true;
					TenUp3.getInstance().overlayColor = Color.fromValue(0x00000000);
				case THROW:
					var from = sprites[0];
					var to = sprites[1];
					var proj = sprites[2];
					var spos = new Vector2(from.x + 0.5 * from.y, from.y + 0.5 * from.height);
					var dpos = new Vector2(to.x + 0.5 * to.width, to.y + 0.5 * to.height);
					var speed = dpos.sub(spos);
					speed.length = proj.speedx;
					proj.x = spos.x;
					proj.y = spos.y;
					proj.speedx = speed.x;
					proj.speedy = speed.y;
					proj.maxspeedy = speed.y;
					proj.accx = 0;
					proj.accy = 0;
					Scene.the.addProjectile(proj);
			}
			return;
		} else {
			switch(type) {
				case ActionType.MG:
					// TODO
					actionFinished();
				case ActionType.FADE:
					++counter;
					if (counter >= 512) {
						actionFinished();
					} else if (counter >= 256) {
						TenUp3.getInstance().overlayColor.Ab = 512 - counter;
					} else {
						TenUp3.getInstance().overlayColor.Ab = counter;
					}
				case ActionType.THROW:
					actionFinished();
			}
		}
	}
	
	@:access(Dialogue.isActionActive) 
	function actionFinished() {
		finished = true;
		if (autoAdvance) {
			Dialogue.next();
		}
	}
}
