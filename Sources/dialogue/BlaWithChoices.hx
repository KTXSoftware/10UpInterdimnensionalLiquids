package dialogue;

import Dialogue.DialogueItem;
import kha.input.Keyboard;
import kha.Key;
import kha.Sprite;

using StringTools;

enum BlaWithChoicesStatus {
	BLA;
	CHOICE;
	ROUTED;
}

class BlaWithChoices extends Bla {
	var choices : Array<DialogueItem>;
	var choice : Int;
	var status : BlaWithChoicesStatus = BlaWithChoicesStatus.BLA;
	
	public function new (text : String, speaker : Sprite, choices: Array<DialogueItem>) {
		super(text, speaker);
		
		this.choices = choices;
		
		this.finished = false;
	}
	
	private function keyUpListener(key:Key, char: String) {
		var choice = char.fastCodeAt(0) - '1'.fastCodeAt(0);
		if (choice >= 0 && choice < choices.length) {
			Keyboard.get().remove(null, keyUpListener);
			status = BlaWithChoicesStatus.ROUTED;
		}
	}
	
	override public function execute() : Void {
		switch (status) {
			case BlaWithChoicesStatus.BLA:
				super.execute();
				Keyboard.get().notify(null, keyUpListener);
			case BlaWithChoicesStatus.CHOICE:
				// just wait for input
			case BlaWithChoicesStatus.ROUTED:
				var routedItem = choices[choice];
				if (routedItem != null) {
					routedItem.execute();
					finished = routedItem.finished;
				} else {
					finished = true;
				}
		}
	}
}
