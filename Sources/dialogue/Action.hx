package dialogue;

import Dialogue.DialogueItem;
import kha.Color;
import kha.Sprite;

enum ActionType {
	MG;
	FADE;
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
