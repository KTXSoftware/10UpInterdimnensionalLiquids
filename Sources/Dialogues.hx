package;

import dialogue.Action;
import dialogue.Bla;
import dialogue.BlaWithChoices;
import kha.Scene;
import kha.Sprite;

class TxtKeys {
	static public inline var START_DLG_1 = "Start_Dlg_1";
	static public inline var CHAR_MANN = "Mann";
	static public inline var CHAR_FRAU = "Frau";
	static public inline var CHAR_VERKAEUFERING = "Verkaeuferin";
	static public inline var CHAR_TERRORIST = "Terrorist";
	static public inline var CHAR_MECHANIC = "Mechanic";
	static public inline var CHAR_PROFESSOR = "Professor";
	static public inline var CHAR_FISCHMENSCH = "Fischmensch";

	static public inline var DLG_START_1 = "Start_Dlg_1";
	static public inline var DLG_START_2 = "Start_Dlg_2";
	static public inline var DLG_START_3 = "Start_Dlg_3";
	static public inline var DLG_START_4 = "Start_Dlg_4";
	static public inline var DLG_START_5 = "Start_Dlg_5";
	static public inline var DLG_START_6 = "Start_Dlg_6";

	static public inline var DLG_GELD_GEFUNDEN_C = "Geld_Gefunden_c";

	static public inline var DLG_VERKAUFEN_1 = "Verkaufen_1";
	static public inline var DLG_VERKAUFEN_2_C = "Verkaufen_2_c";

	static public inline var DLG_VERKAUFEN_2A_1 = "Verkaufen_2a_1";
	static public inline var DLG_VERKAUFEN_2A_2_C = "Verkaufen_2a_2_c";
	static public inline var DLG_VERKAUFEN_2A_2_GELD = "Verkaufen_2a_2_GELD";

	static public inline var DLG_VERKAUFEN_2A_2A_1 = "Verkaufen_2a_2a_1";
	static public inline var DLG_VERKAUFEN_2A_2A_2 = "Verkaufen_2a_2a_2";
	static public inline var DLG_VERKAUFEN_2A_2A_3_c = "Verkaufen_2a_2a_3_c";

	static public inline var DLG_VERKAUFEN_2A_2A_3A_1 = "Verkaufen_2a_2a_3a_1";
	static public inline var DLG_VERKAUFEN_2A_2A_3B_1 = "Verkaufen_2a_2a_3b_1";

	static public inline var DLG_VERKAUFEN_2A_2B_1_C = "Verkaufen_2a_2b_1_c";
	static public inline var DLG_VERKAUFEN_2A_2B_1A_1 = "Verkaufen_2a_2b_1a_1";

	static public inline var DLG_VERKAUFEN_2B_1 = "Verkaufen_2b_1";
	static public inline var DLG_VERKAUFEN_2B_2 = "Verkaufen_2b_2";

	static public inline var DLG_VERKAUFEN_ERFOLG_1 = "Verkaufen_Erfolg_1";
	static public inline var DLG_VERKAUFEN_ERFOLG_2 = "Verkaufen_Erfolg_2";
}

class Dialogues {
	
	static public function setStartDlg(mann: Sprite, eheweib: Sprite) {
		Dialogue.set([new Bla(Localization.getText(TxtKeys.DLG_START_1), mann)
					 ,new Bla(Localization.getText(TxtKeys.DLG_START_2), eheweib)
					 ,new Bla(Localization.getText(TxtKeys.DLG_START_3), eheweib)
					 ,new Bla(Localization.getText(TxtKeys.DLG_START_4), mann)
					 ,new Bla(Localization.getText(TxtKeys.DLG_START_5), eheweib)
					 ,new Bla(Localization.getText(TxtKeys.DLG_START_6), mann)]);
	}
	
	static public function setGeldGefundenDlg(mann: Sprite, coin: Sprite) {
		Dialogue.set([new BlaWithChoices(Localization.getText(TxtKeys.DLG_GELD_GEFUNDEN_C), mann, [new Action([mann, coin], ActionType.TAKE), null])]);
	}
	
	static public function setVerkaufDlg(mann: Sprite, verkaeuferin: Sprite) {
		var part2a = new Bla("TODO", mann);
		var part2b = new Bla("TODO", mann);
		var part2 : Array<Dialogue.DialogueItem> = [part2a, part2b];
		var part1 = [new Bla(Localization.getText(TxtKeys.DLG_VERKAUFEN_1), verkaeuferin), new BlaWithChoices(Localization.getText(TxtKeys.DLG_VERKAUFEN_2_C), mann, part2)];
	}
}
