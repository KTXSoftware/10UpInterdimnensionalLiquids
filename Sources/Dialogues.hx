package;

import dialogue.Action;
import dialogue.Bla;
import dialogue.BlaWithChoices;
import dialogue.Branch.BooleanBranch;
import dialogue.Branch.IntBranch;
import dialogue.EndGame;
import dialogue.InventoryAction;
import dialogue.SetVictoryCondition;
import dialogue.StartDialogue;
import Cfg;
import haxe.macro.Expr.Var;
import localization.Keys_text;
import kha.Scene;
import kha.Sprite;

using Lambda;

class Dialogues {
		
	static public function startProfStartDialog(prof: Sprite) {
		Dialogue.insert([new Bla(Keys_text.PROF1, prof), new Bla(Keys_text.PROF2, prof), new Bla(Keys_text.PROF3, prof), new Bla(Keys_text.PROF4, prof), new Bla(Keys_text.PROF5, prof)]);
	}
	
	static public function startProfGotItDialog(prof: Sprite) {
		Dialogue.insert([new Bla(Keys_text.PROF6, prof)]);
	}
	
	static public function startProfWinDialog(prof: Sprite) {
		Dialogue.insert([new Bla(Keys_text.PROF7, prof)]);
	}
	
	static public function startProfLooseDialog(prof: Sprite) {
		Dialogue.insert([new Bla(Keys_text.PROF8, prof)]);
	}
	
	static public function setStartDlg() {
		var mann = Cfg.mann;
		var eheweib = Cfg.eheweib;
		Dialogue.insert([new Bla(Keys_text.DLG_START_1, mann)
					 ,new Bla(Keys_text.DLG_START_2, eheweib)
					 ,new Bla(Keys_text.DLG_START_3, eheweib)
					 ,new Bla(Keys_text.DLG_START_4, mann)
					 ,new Bla(Keys_text.DLG_START_5, eheweib)
					 ,new Bla(Keys_text.DLG_START_6, mann)]);
	}
	
	static public function setGeldGefundenMannDlg() {
		var mann = Cfg.mann;
		var cent = Cfg.cent;
		Dialogue.insert([
			new BlaWithChoices(Localization.getText(Keys_text.DLG_GELD_GEFUNDEN_1_C), mann, [
				[ new InventoryAction(mann, cent, InventoryActionMode.PICKUP), new SetVictoryCondition(VictoryCondition.CENT_TAKEN, true) ]
				, [ new SetVictoryCondition(VictoryCondition.CENT_TAKEN, false) ]
			])
		]);
	}
	
	static public function setGeldVerlohrenVerkDlg() {
		var verkaeuferin = Cfg.verkaeuferin;
		var cent = Cfg.cent;
		Dialogue.insert([
			new InventoryAction(verkaeuferin, cent, InventoryActionMode.DROP)
			, new BlaWithChoices(Keys_text.DLG_GELD_VERLOHREN_1_C, verkaeuferin, [
				[ new InventoryAction(verkaeuferin, cent, InventoryActionMode.PICKUP), new SetVictoryCondition(VictoryCondition.CENT_DROPPED, false), new SetVictoryCondition(VictoryCondition.CENT_TAKEN, false) ]
				, [ new SetVictoryCondition(VictoryCondition.CENT_DROPPED, true) ]
			])
		]);
	}
	
	static public function setVerkaufMannDlg() {
		var mann = Cfg.mann;
		var verkaeuferin = Cfg.verkaeuferin;
		var euro = Cfg.euro;
		var cent = Cfg.cent;
		var broetchen = Cfg.broetchen;
		var part1 = [
			new Bla(Keys_text.DLG_VERKAUFEN_1, verkaeuferin)
			, new BlaWithChoices(Keys_text.DLG_VERKAUFEN_2_C, mann, [
				[ // Antwort 1
					new Bla(Keys_text.DLG_VERKAUFEN_2A_1, verkaeuferin)
					, new BooleanBranch(Cfg.getVictoryCondition.bind(VictoryCondition.CENT_TAKEN)
						, [ // HAS CENT
							new Bla(Keys_text.DLG_VERKAUFEN_2A_2_GELD, mann)
							, new InventoryAction(mann, euro, InventoryActionMode.REMOVE)
							, new InventoryAction(mann, cent, InventoryActionMode.REMOVE)
							, new SetVictoryCondition(VictoryCondition.MEHRKORN, true)
							, new SetVictoryCondition(VictoryCondition.MATHEGENIE, true)
						] 
						, [ // ONLY ONE EURO
							new BlaWithChoices(Keys_text.DLG_VERKAUFEN_2A_2_C, mann, [
								[ // Antwort 1
									new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_1, verkaeuferin)
									, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_2, verkaeuferin)
									, new IntBranch(Cfg.getDlgChoice.bind(Keys_text.DLG_VERKAUFEN_2A_2A_3_C), [
										[ // Antwort 1: Da kann ich nix machen
											new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A, verkaeuferin)
											, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A_1, mann)
											, new InventoryAction(mann, euro, InventoryActionMode.REMOVE)
											, new SetVictoryCondition(VictoryCondition.MEHRKORN, false)
											, new SetVictoryCondition(VictoryCondition.MATHEGENIE, true)
										]
										, [ // Antwort 2: sehe darüber hinweg
											new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3B, verkaeuferin)
											, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3B_1, mann)
											, new InventoryAction(mann, euro, InventoryActionMode.REMOVE)
											, new SetVictoryCondition(VictoryCondition.MEHRKORN, true)
											, new SetVictoryCondition(VictoryCondition.MATHEGENIE, false)
										]
									])
								]
								, [ // Antwort 2
									new IntBranch(Cfg.getDlgChoice.bind(Keys_text.DLG_VERKAUFEN_2A_2B_1_C), [
										[ // Antwort 1
											new InventoryAction(mann, euro, InventoryActionMode.REMOVE)
											, new Bla(Keys_text.DLG_VERKAUFEN_2A_2B_1A, verkaeuferin)
											, new Bla(Keys_text.DLG_VERKAUFEN_2A_2B_1A_1, mann)
											, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A, verkaeuferin)
											, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A_1, mann)
											, new SetVictoryCondition(VictoryCondition.MEHRKORN, false)
										]
										, [ // Antwort 2
											new InventoryAction(mann, euro, InventoryActionMode.REMOVE)
											, new SetVictoryCondition(VictoryCondition.MEHRKORN, true)
											, new SetVictoryCondition(VictoryCondition.MATHEGENIE, false)
										]
									])
								]
							])
						]
					)
				]
				, [ // Antwort 2
					new Bla(Keys_text.DLG_VERKAUFEN_2B_1, verkaeuferin)
					, new Bla(Keys_text.DLG_VERKAUFEN_2B_2, mann)
					, new InventoryAction(mann, euro, InventoryActionMode.REMOVE)
					, new SetVictoryCondition(VictoryCondition.MEHRKORN, false)
				]
			] )
			, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_1,verkaeuferin)
			, new InventoryAction(mann, broetchen, InventoryActionMode.ADD)
			, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_2,mann)
		];
		Dialogue.insert(part1);
	}
	
	static public function setVerkaufVerkDlg() {
		var mann = Cfg.mann;
		var verkaeuferin = Cfg.verkaeuferin; 
		Dialogue.insert( [
			new Bla(Keys_text.DLG_VERKAUFEN_1, verkaeuferin)
			, new IntBranch(Cfg.getDlgChoice.bind(Keys_text.DLG_VERKAUFEN_2_C), [
				[ // Antwort 1: Richtige Brötchen
					new BooleanBranch(Cfg.getVictoryCondition.bind(VictoryCondition.CENT_TAKEN)
						, [ // Cent
							new Bla(Keys_text.DLG_VERKAUFEN_2A, mann)
							, new Bla(Keys_text.DLG_VERKAUFEN_2A_1, verkaeuferin) 
							, new Bla(Keys_text.DLG_VERKAUFEN_2A_2_GELD, mann)
							, new SetVictoryCondition(VictoryCondition.MEHRKORN, true)
							, new SetVictoryCondition(VictoryCondition.MATHEGENIE, true)
							, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_1, verkaeuferin)
						]
						, [ // no cent
							new Bla(Keys_text.DLG_VERKAUFEN_2A, mann)
							, new Bla(Keys_text.DLG_VERKAUFEN_2A_1, verkaeuferin)
							, new IntBranch(Cfg.getDlgChoice.bind(Keys_text.DLG_VERKAUFEN_2A_2_C), [
								[ // Antwort 1: hab nur 1 euro
									new Bla(Keys_text.DLG_VERKAUFEN_2A_2A, mann)
									, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_1, verkaeuferin)
									, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_2, verkaeuferin)
									, new BlaWithChoices(Keys_text.DLG_VERKAUFEN_2A_2A_3_C, verkaeuferin, [
										[ // Antwort 1: Da kann ich nix machen
											new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A_1, mann)
											, new SetVictoryCondition(VictoryCondition.MEHRKORN, false)
											, new SetVictoryCondition(VictoryCondition.MATHEGENIE, true)
											, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_1, verkaeuferin)
										]
										, [ // Antwort 2: Sehe darüber hinweg
											new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3B_1, mann)
											, new SetVictoryCondition(VictoryCondition.MEHRKORN, true)
											, new SetVictoryCondition(VictoryCondition.MATHEGENIE, false)
											, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_1, verkaeuferin)
										]
									])
								]
								, [ // Antwort 2: Gibt einen euro
									new Bla(Keys_text.DLG_VERKAUFEN_2A_2B, mann)
									, new BlaWithChoices(Keys_text.DLG_VERKAUFEN_2A_2B_1_C, verkaeuferin, [
										[ // Antwort 1: Entschuldigen sie Bitte!
											new Bla(Keys_text.DLG_VERKAUFEN_2A_2B_1A_1, mann)
											, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_1, verkaeuferin)
											, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_2, verkaeuferin)
											, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A, verkaeuferin)
											, new Bla(Keys_text.DLG_VERKAUFEN_2A_2A_3A_1, mann)
											, new SetVictoryCondition(VictoryCondition.MEHRKORN, false)
											, new SetVictoryCondition(VictoryCondition.MATHEGENIE, true)
											, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_1, verkaeuferin)
										]
										, [ // Antwort 2: Und hier ihre Brötchen
											new SetVictoryCondition(VictoryCondition.MEHRKORN, true)
											, new SetVictoryCondition(VictoryCondition.MATHEGENIE, false)
										]
									])
								]
							])
						]
					)
				]
				, [ // Antwort 2: Zwo Wasserweck
					new Bla(Keys_text.DLG_VERKAUFEN_2B, mann)
					, new Bla(Keys_text.DLG_VERKAUFEN_2B_1, verkaeuferin) 
					, new Bla(Keys_text.DLG_VERKAUFEN_2B_2, mann)
					, new SetVictoryCondition(VictoryCondition.MEHRKORN, false)
					, new SetVictoryCondition(VictoryCondition.MATHEGENIE, true)
					, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_1, verkaeuferin)
				]
			])
			, new Bla(Keys_text.DLG_VERKAUFEN_ERFOLG_2,mann)
		] );
	}
	
	
	static public function setGefeuertDlg() {
		var verkaeuferin = Cfg.verkaeuferin;	
		var mafioso = Cfg.mafioso;
		Dialogue.insert( [
			new Bla(Keys_text.DLG_ARBEITSLOS_1, mafioso)
			, new Bla(Keys_text.DLG_ARBEITSLOS_2, mafioso)
			, new BlaWithChoices(Keys_text.DLG_ARBEITSLOS_3_C, verkaeuferin, [
				[new Bla(Keys_text.DLG_ARBEITSLOS_3A_1, mafioso), new EndGame()]
				, [new Bla(Keys_text.DLG_ARBEITSLOS_3B_1, mafioso), new Action([mafioso], ActionType.MG)]
			])
		] );
	}
	
	static public function setMannEndeDlg() {
		
	}
	
	static public function setVerkEndeDlg() {
		
	}
	
	static public function setTestDlg(mann : ZeroEightFifteenMan, eheweib: Sprite, verkaeuferin: Verkaeuferin, euro: Sprite, cent: Sprite, broetchen: Sprite) {
		var t2 = new StartDialogue(setTestDlg.bind(mann, eheweib, verkaeuferin, euro, cent, broetchen));
		
		var test = new BlaWithChoices("Welchen Dialog testen?\n"
			+ "(1): Geld Gefunden\n"
			+ "(2): Geld Verlohren\n"
			+ "(3): Brötchen kaufen\n"
			+ "(4): Brötchen verkaufen\n"
			+ "(5): Gefeuert werden\n", mann, [
				[new StartDialogue(setGeldGefundenMannDlg), t2]
				, [new StartDialogue(setGeldVerlohrenVerkDlg), t2]
				, [new StartDialogue(setVerkaufMannDlg), t2 ]
				, [new StartDialogue(setVerkaufVerkDlg), t2 ]
				, [new StartDialogue(setGefeuertDlg), t2 ]
			]);
		
		Dialogue.insert([ test ]);
	}
}
