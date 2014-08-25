package dialogue;
import kha.Scene;
import localization.Keys_text;

class ShowOther extends Bla
{
	public function new() {
		super(Keys_text.GAME_ABER, null);
	}
	
	override public function execute(): Void {
		if (Player.current() == Cfg.mann) {
			// mann => verkäuferin
			Cfg.verkaeuferin.x = Cfg.verkaeuferinPositions[1].x;
			Cfg.verkaeuferin.y = Cfg.verkaeuferinPositions[1].y;
			Cfg.verkaeuferin.lookRight = true;
			Scene.the.removeHero(Cfg.verkaeuferin);
			Scene.the.addHero(Cfg.verkaeuferin);
			Cfg.verkaeuferin.setCurrent();
			Dialogues.setGefeuertDlg();
		} else {
			// verkäuferin => mann
			Cfg.mann.x = Cfg.mannPositions[0].x;
			Cfg.mann.y = Cfg.verkaeuferinPositions[0].y;
			Cfg.mann.lookRight = false;
			Scene.the.removeHero(Cfg.verkaeuferin);
			Scene.the.addHero(Cfg.verkaeuferin);
			Cfg.verkaeuferin.setCurrent();
			Dialogues.setGefeuertDlg();
		}
		super.execute();
	}
}