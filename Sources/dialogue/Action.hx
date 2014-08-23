package dialogue;

import Dialogue.DialogueItem;
import kha.Sprite;

enum ActionType {
	TAKE;
	GIVE;
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
				case ActionType.TAKE:
					// TODO
				case ActionType.GIVE:
					// TODO
			}
			return;
		} else {
			switch(type) {
				case ActionType.TAKE:
					// TODO
				case ActionType.GIVE:
					// TODO
			}
		}
		actionFinished();
	}
	
	@:access(Dialogue.isActionActive) 
	function actionFinished() {
		finished = true;
		if (autoAdvance) {
			Dialogue.next();
		}
	}
}
