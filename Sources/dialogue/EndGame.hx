package dialogue;

class EndGame implements Dialogue.DialogueItem
{
	public function new() {
	}
	
	public var finished(default, null) : Bool = false;
	
	public function execute(): Void {
		BlaBox.setText("SPIEL ENDE");
		// TODO: display endgame
	}
}