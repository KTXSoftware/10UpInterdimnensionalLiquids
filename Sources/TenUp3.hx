package;

import dialogue.BlaWithChoices;
import dialogue.StartDialogue;
import kha.Assets;
import kha.Color;
import kha.Font;
import kha.FontStyle;
import kha.Framebuffer;
import kha.graphics4.TextureFormat;
import kha.Image;
import kha.input.Gamepad;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import kha.math.FastMatrix3;
import kha.math.Random;
import kha.Scaler;
import kha2d.Scene;
import kha.Scheduler;
import kha.ScreenRotation;
import kha2d.Sprite;
import kha.Sound;
import kha.Storage;
import kha.System;
import kha2d.Tile;
import kha2d.Tilemap;
import localization.Keys_text;

enum SubGame {
	TEN_UP_3;
	JUST_A_NORMAL_DAY;
}

enum Mode {
	Menu;
	Game;
	BlaBlaBla;
}

class TenUp3 {
	public static inline var width = 960;
	public static inline var height = 600;
	public static var instance : TenUp3;
	var music : Sound;
	var tileColissions : Array<Tile>;
	var map : Array<Array<Int>>;
	var originalmap : Array<Array<Int>>;
	var highscoreName : String;
	var shiftPressed : Bool;
	private var font: Font;
	private var fontSize: Int;
	private var backbuffer: Image;
	
	public var mouseX: Float;
	public var mouseY: Float;
	private var screenMouseX: Float;
	private var screenMouseY: Float;
	
#if JUST_A_NORMAL_DAY
	var subgame : SubGame = SubGame.JUST_A_NORMAL_DAY;
#else
	var subgame : SubGame = SubGame.TEN_UP_3;
#end
	var mode : Mode;
	
	public function new() {
		instance = this;
		shiftPressed = false;
		highscoreName = "";
		mode = Mode.Game;
		System.init({title: "10Up: Interdimensional Liquids", width: width, height: height}, init);
	}
	
	public static function getInstance(): TenUp3 {
		return instance;
	}
	
	function init(): Void {
		Player.init();
		Assets.loadEverything(initMenu);
	}
	
	function initMenu() {
		Scene.the.setSize(width, height);
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
		Localization.init("localizations_xml");
		
		backbuffer = Image.createRenderTarget(960, 600);
		
		Cfg.init();
		if (Cfg.language == null) {
			var msg = "Please select your language:";
			var choices = new Array<Array<Dialogue.DialogueItem>>();
			var i = 1;
			for (l in Localization.availableLanguages.keys()) {
				choices.push([new StartDialogue(function() { Cfg.language = l; } )]);
				msg += '\n($i): ${Localization.availableLanguages[l]}';
				++i;
			}
			Dialogue.set( [
				new BlaWithChoices(msg, null, choices)
				, new StartDialogue(Cfg.save)
				, new StartDialogue(advanceMenu)
			] );
		} else {
			advanceMenu();
		}
	}
	
	function advanceMenu() {
		Localization.language = Cfg.language;
		
		Localization.buildKeys("../Assets/Blobs/text.xml", "text");
		//Localization.load("text");
		
		loadTheOneAndOnlyLevel();
	}
	
	public function loadTheOneAndOnlyLevel() {
		Level.load("level1", initLevel);
	}

	function initLevel(): Void {
		Dialogue.set(null);
		font = Assets.fonts.arial;
		fontSize = 12;
		startGame();
	}
	
	public function startGame() {
		switch(subgame) {
		case SubGame.TEN_UP_3:
			startGame_TenUp3();
		case SubGame.JUST_A_NORMAL_DAY:
			startGame_JustANormalDay();
		}
		if (Gamepad.get(0) != null) Gamepad.get(0).notify(axisListener, buttonListener);
		Keyboard.get().notify(keydown, keyup);
		Mouse.get().notify(mousedown, mouseup, mousemove, mousewheel);
	}
	
	private var inventorySelection: Int = 0;
	
	public function startGame_TenUp3() {
		var prof = new PlayerProfessor(400, 10);
		prof.setCurrent();
		Scene.the.addHero(prof);
		prof.inventory.pick(new Sprite(Assets.images.waterflow));
		prof.inventory.pick(new Sprite(Assets.images.lavaflow));
		prof.inventory.pick(new Sprite(Assets.images.gasflow));
		prof.inventory.pick(new Sprite(Assets.images.noflow));
		prof.inventory.selectIndex(0);
		Dialogues.startProfStartDialog(prof);
	}
	
	var cfg: Cfg;
	function startGame_JustANormalDay() {
		//kha.Sys.mouse.hide();
		overlayColor = Color.Black;
		renderOverlay = true;
		if (Cfg.getVictoryCondition(VictoryCondition.PLAYED_MANN) == Cfg.getVictoryCondition(VictoryCondition.PLAYED_VERKAEUFERIN)) {
			Dialogue.insert( [
				new BlaWithChoices(Keys_text.DLG_SELECT_ROLE, null, [
					[ new StartDialogue(initMan) ]
					, [ new StartDialogue(initSeller) ]
					, [ new StartDialogue((Math.random() < 0.5) ? initMan : initSeller) ]
				])
			] );
		} else if (!Cfg.getVictoryCondition(VictoryCondition.PLAYED_MANN)) {
			initMan();
		} else {
			initSeller();
		}
	}
	
	function initMan() {
		// Reset Victory conditions:
		Cfg.setVictoryCondition(VictoryCondition.BOUGHT_ROLLS, false);
		Cfg.setVictoryCondition(VictoryCondition.DELIVERED_ROLLS, false);
		Cfg.setVictoryCondition(VictoryCondition.MEHRKORN, false);
		Cfg.setVictoryCondition(VictoryCondition.CENT_TAKEN, false);
		
		
		Cfg.mann.setCurrent();
		Cfg.mann.disableActions = false;
		Cfg.mann.lookRight = false;
		Scene.the.addHero(Cfg.mann);
		
		
		Cfg.mann.inventory.pick(Cfg.euro);
		
		if (Cfg.getVictoryCondition(VictoryCondition.CENT_DROPPED)) {
			Cfg.cent.x = Cfg.verkaeuferin.x + 150;
			Cfg.cent.y = Cfg.verkaeuferin.y;
			Scene.the.addOther(Cfg.cent);
		}
		
		
		Cfg.verkaeuferin.lookRight = false;
		Cfg.verkaeuferin.x = Cfg.verkaeuferinPositions[1].x;
		Cfg.verkaeuferin.y = Cfg.verkaeuferinPositions[1].y;
		Scene.the.addHero(Cfg.verkaeuferin);
		Cfg.verkaeuferin.operateTheke(true);
		
		Dialogues.setStartDlg();
	}
	
	function initSeller() {
		// Reset Victory conditions:
		Cfg.setVictoryCondition(VictoryCondition.MATHEGENIE, false);
		Cfg.setVictoryCondition(VictoryCondition.CENT_DROPPED, false);
		
		Cfg.verkaeuferin.setCurrent();
		Cfg.verkaeuferin.disableActions = false;
		Scene.the.addHero(Cfg.verkaeuferin);
		
		// Play as Verkäuferin
		Cfg.verkaeuferin.inventory.pick(Cfg.cent);
		
		Cfg.mann.inventory.pick(Cfg.euro); // allways needed
		
		Dialogues.setVerkStartDlg();
	}
	
	function update() {
		Scene.the.update();
		updateMouse();
		var player = Player.current();
		if (player != null) {
			Scene.the.camx = Std.int(player.x) + Std.int(player.width / 2);
			switch (subgame) {
				case TEN_UP_3:
					Scene.the.camy = Std.int(player.y) + Std.int(player.height / 2);
				case JUST_A_NORMAL_DAY:
					Scene.the.camy = Std.int(player.y + player.height + 80 - 0.5 * height);
			}
		}
		if (advanceDialogue) {
			Dialogue.next();
			advanceDialogue = false;
		}
		switch (mode) {
		case BlaBlaBla:
			Dialogue.update();
		default:
		}
	}
	
	public var renderOverlay : Bool;
	public var overlayColor : Color;
	
	function render(frame: Framebuffer) {
		var g = backbuffer.g2;
		g.begin();
		Scene.the.render(g);
		g.transformation = FastMatrix3.identity();
		if (Player.current() != null) {
			Player.current().inventory.render(g);
		}
		if (renderOverlay) {
			g.color = overlayColor;
			g.fillRect(0, 0, width, height);
		}
		BlaBox.render(g);
		g.end();
		
		frame.g2.begin();
		Scaler.scale(backbuffer, frame, System.screenRotation);
		frame.g2.end();
	}
	
	private function axisListener(axis: Int, value: Float): Void {
		switch (axis) {
			case 0:
				if (value < -0.2) {
					Player.current().left = true;
					Player.current().right = false;
				}
				else if (value > 0.2) {
					Player.current().right = true;
					Player.current().left = false;
				}
				else {
					Player.current().left = false;
					Player.current().right = false;
				}
		}
	}
	
	private function buttonListener(button: Int, value: Float): Void {
		switch (button) {
			case 0, 1, 2, 3:
				if (value > 0.5) Player.current().setUp();
				else Player.current().up = false;
			case 14:
				if (value > 0.5) {
					Player.current().left = true;
					Player.current().right = false;
				}
				else {
					Player.current().left = false;
					Player.current().right = false;
				}
			case 15:
				if (value > 0.5) {
					Player.current().right = true;
					Player.current().left = false;
				}
				else {
					Player.current().right = false;
					Player.current().left = false;
				}
		}
	}

	public function keydown(key: KeyCode) : Void {
		if (mode == Mode.Game) {
			switch (key) {
				case Control:
					Dialogue.next();
				case One:
					Player.current().inventory.selectIndex(0);
				case Two:
					Player.current().inventory.selectIndex(1);
				case Three:
					Player.current().inventory.selectIndex(2);
				case Four:
					Player.current().inventory.selectIndex(3);
				case Left, A:
					Player.current().left = true;
				case Right, D:
					Player.current().right = true;
				case Up, W:
					Player.current().setUp();
				default:
			}
		}
	}
	
	public function keyup(key: KeyCode) : Void {
		switch (key) {
			case Escape:
				{
				var msg = "What to do?\n(1): Restart";
					var choices = new Array<Array<Dialogue.DialogueItem>>();
					choices.push( [ new StartDialogue(Dialogues.restartGameDlg) ] );
					var i = 2;
					for (l in Localization.availableLanguages.keys()) {
						if (l != Cfg.language) {
							choices.push([new StartDialogue(function() { Cfg.language = l; } )]);
							msg += '\n($i): Set language to "${Localization.availableLanguages[l]}"';
							++i;
						}
					}
					msg += '\n($i): Back"';
					choices.push( [] );
					Dialogue.insert( [
						new BlaWithChoices(msg, null, choices)
						, new StartDialogue(Cfg.save)
						, new StartDialogue(function () { Localization.language = Cfg.language; } )
					], true );
				}
			case Control:
				Player.current().up = false;
			case Left, A:
				Player.current().left = false;
			case Right, D:
				Player.current().right = false;
			case Up, W:
				Player.current().up = false;
			default:
		}
	}
	
	private function updateMouse(): Void {
		mouseX = screenMouseX + Scene.the.screenOffsetX;
		mouseY = screenMouseY + Scene.the.screenOffsetY;
	}

	public function mousedown(button: Int, x: Int, y: Int): Void {
		screenMouseX = x;
		screenMouseY = y;
		updateMouse();
		switch (subgame) {
			case SubGame.TEN_UP_3:
				switch(mode) {
					case Mode.Game:
						Player.current().useSpecialAbilityA();
					default:
				}
			case SubGame.JUST_A_NORMAL_DAY:
				
		}
	}
	
	public var advanceDialogue: Bool = false;
	public function mouseup(button: Int, x: Int, y: Int): Void {
		screenMouseX = x;
		screenMouseY = y;
		updateMouse();
		if (mode == BlaBlaBla) {
			advanceDialogue = true;
		}
	}
	
	public function mousemove(x: Int, y: Int, mx: Int, my: Int): Void {
		screenMouseX = x;
		screenMouseY = y;
		updateMouse();
	}
	
	public function mousewheel(delta: Int): Void {
		if (delta > 0) {
			--inventorySelection;
			if (inventorySelection < 0) inventorySelection = 3;
		}
		else {
			++inventorySelection;
			if (inventorySelection > 3) inventorySelection = 0;
		}
		Player.current().inventory.selectIndex(inventorySelection);
	}
}
