package;

import kha.Button;
import kha.Color;
import kha.Font;
import kha.FontStyle;
import kha.Framebuffer;
import kha.Game;
import kha.graphics4.TextureFormat;
import kha.HighscoreList;
import kha.Image;
import kha.input.Gamepad;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.Key;
import kha.Loader;
import kha.LoadingScreen;
import kha.math.Matrix3;
import kha.math.Random;
import kha.Music;
import kha.Scaler;
import kha.Scene;
import kha.Scheduler;
import kha.Score;
import kha.Configuration;
import kha.ScreenRotation;
import kha.SoundChannel;
import kha.Sprite;
import kha.Storage;
import kha.Tile;
import kha.Tilemap;

enum SubGame {
	TEN_UP_3;
	JUST_A_NORMAL_DAY;
}

enum Mode {
	Game;
	BlaBlaBla;
}

class TenUp3 extends Game {
	public static var instance : TenUp3;
	var music : Music;
	var tileColissions : Array<Tile>;
	var map : Array<Array<Int>>;
	var originalmap : Array<Array<Int>>;
	var highscoreName : String;
	var shiftPressed : Bool;
	private var font: Font;
	private var backbuffer: Image;
	
	public var mouseX: Float;
	public var mouseY: Float;
	
	var player: Player;
	
#if JUST_A_NORMAL_DAY
	var subgame : SubGame = SubGame.JUST_A_NORMAL_DAY;
#else
	var subgame : SubGame = SubGame.TEN_UP_3;
#end
	var mode : Mode;
	
	public function new() {
		super("SML", true);
		instance = this;
		shiftPressed = false;
		highscoreName = "";
		mode = Mode.Game;
	}
	
	public static function getInstance(): TenUp3 {
		return instance;
	}
	
	public override function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		//Loader.the.loadRoom("level1", initLevel);
		Level.load("level1", initLevel);
	}

	public function initLevel(): Void {
		Random.init(Std.int(Scheduler.time() * 10000));
		backbuffer = Image.createRenderTarget(800, 600);
		font = Loader.the.loadFont("Arial", new FontStyle(false, false, false), 12);
		startGame();
	}
	
	public function startGame() {
		Localization.language = Localization.LanguageType.en; // TODO: language select
		Localization.buildKeys("../Assets/text.xml","text");
		//Localization.init("text");
		Inventory.init();
		
		switch(subgame) {
		case SubGame.TEN_UP_3:
			startGame_TenUp3();
		case SubGame.JUST_A_NORMAL_DAY:
			startGame_JustANormalDay();
		}
		if (Gamepad.get(0) != null) Gamepad.get(0).notify(axisListener, buttonListener);
		Keyboard.get().notify(keydown, keyup);
		Mouse.get().notify(mousedown, mouseup, mousemove, mousewheel);
		
		Configuration.setScreen(this);
	}
	
	private var inventorySelection: Int = 0;
	
	public function startGame_TenUp3() {
		Player.init();
		player = new PlayerProfessor(400, 10);
		Scene.the.addHero(player);
		Inventory.pick(new Sprite(Loader.the.getImage('waterflow')));
		Inventory.pick(new Sprite(Loader.the.getImage('lavaflow')));
		Inventory.pick(new Sprite(Loader.the.getImage('gasflow')));
		Inventory.pick(new Sprite(Loader.the.getImage('noflow')));
		Inventory.selectIndex(0);
		Dialogues.startProfStartDialog(player);
	}
	
	var justANormalDay: JustANormalDay;
	public function startGame_JustANormalDay() {
		Player.init();
		var mann = new ZeroEightFifteenMan(250, 350);
		
		player = mann;
		Scene.the.addHero(player);
		player.setCurrent();
		
		var euro = new Sprite(Loader.the.getImage("euro"));
		euro.scaleX = euro.scaleY = 0.5;
		var cent = new Sprite(Loader.the.getImage("cent"));
		cent.scaleX = cent.scaleY = 0.5;
		Inventory.pick(euro);
		Inventory.pick(cent);
		
		var eheweib = new Sprite(null, 25, 25);
		eheweib.x = 150;
		eheweib.y = 300;
		eheweib.accy = 0;
		Scene.the.addEnemy(eheweib);
		
		var verkaeuferin = new Verkaeuferin(400, 350);
		Scene.the.addHero(verkaeuferin);
		
		justANormalDay = new JustANormalDay(mann, eheweib, verkaeuferin);
		
		//Dialogues.setStartDlg(mann, eheweib);
		Dialogues.setTestDlg(mann, eheweib, verkaeuferin, euro, cent, null);
	}
	
	public override function update() {
		super.update();
		Scene.the.camx = Std.int(player.x) + Std.int(player.width / 2);
		switch (subgame) {
			case TEN_UP_3:
				Scene.the.camy = Std.int(player.y) + Std.int(player.height / 2);
			case JUST_A_NORMAL_DAY:
				Scene.the.camy = Std.int(player.y - 0.35 * height) + Std.int(player.height / 2);
				justANormalDay.update(Scheduler.time());
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
	
	public override function render(frame: Framebuffer) {
		var g = backbuffer.g2;
		g.begin();
		scene.render(g);
		g.transformation = Matrix3.identity();
		Inventory.render(g);
		BlaBox.render(g);
		g.end();
		
		startRender(frame);
		Scaler.scale(backbuffer, frame, kha.Sys.screenRotation);
		endRender(frame);
	}
	
	private function axisListener(axis: Int, value: Float): Void {
		switch (axis) {
			case 0:
				if (value < -0.2) {
					player.left = true;
					player.right = false;
				}
				else if (value > 0.2) {
					player.right = true;
					player.left = false;
				}
				else {
					player.left = false;
					player.right = false;
				}
		}
	}
	
	private function buttonListener(button: Int, value: Float): Void {
		switch (button) {
			case 0, 1, 2, 3:
				if (value > 0.5) player.setUp();
				else player.up = false;
			case 14:
				if (value > 0.5) {
					player.left = true;
					player.right = false;
				}
				else {
					player.left = false;
					player.right = false;
				}
			case 15:
				if (value > 0.5) {
					player.right = true;
					player.left = false;
				}
				else {
					player.right = false;
					player.left = false;
				}
		}
	}

	public function keydown(key: Key, char: String) : Void {
		if (mode == Mode.Game) {
			switch (key) {
				case Key.CTRL:
					Dialogue.next();
				case Key.CHAR:
					if (char == 'a') {
						player.left = true;
					}
					else if (char == 'd') {
						player.right = true;
					}
					else if (char == 'w') {
						player.setUp();
					}
					else if (char == '1') {
						Inventory.selectIndex(0);
					}
					else if (char == '2') {
						Inventory.selectIndex(1);
					}
					else if (char == '3') {
						Inventory.selectIndex(2);
					}
					else if (char == '4') {
						Inventory.selectIndex(3);
					}
				case Key.LEFT:
					player.left = true;
				case Key.RIGHT:
					player.right = true;
				case Key.UP:
					player.setUp();
				default:
			}
		}
	}
	
	public function keyup(key: Key, char: String) : Void {
		switch (key) {
			case Key.CTRL:
				player.up = false;
			case Key.CHAR:
				if (char == 'a') {
					player.left = false;
				}
				else if (char == 'd') {
					player.right = false;
				}
				else if (char == 'w') {
					player.up = false;
				}
			case Key.LEFT:
				player.left = false;
			case Key.RIGHT:
				player.right = false;
			case Key.UP:
				player.up = false;
			default:
		}
	}

	public function mousedown(button: Int, x: Int, y: Int): Void {
		mouseX = x + Scene.the.screenOffsetX;
		mouseY = y + Scene.the.screenOffsetY;
		switch (subgame) {
			case SubGame.TEN_UP_3:
				switch(mode) {
					case Mode.Game:
						player.useSpecialAbilityA();
					case Mode.BlaBlaBla:
						
				}
			case SubGame.JUST_A_NORMAL_DAY:
				
		}
	}
	
	public var advanceDialogue: Bool = false;
	public function mouseup(button: Int, x: Int, y: Int): Void {
		mouseX = x + Scene.the.screenOffsetX;
		mouseY = y + Scene.the.screenOffsetY;
		if (mode == BlaBlaBla) {
			advanceDialogue = true;
		}
	}
	
	public function mousemove(x: Int, y: Int): Void {
		mouseX = x + Scene.the.screenOffsetX;
		mouseY = y + Scene.the.screenOffsetY;
	}
	
	public function mousewheel(delta: Int): Void {
		if (delta > 0) {
			++inventorySelection;
			if (inventorySelection > 3) inventorySelection = 0;
		}
		else {
			--inventorySelection;
			if (inventorySelection < 0) inventorySelection = 3;
		}
		Inventory.selectIndex(inventorySelection);
	}
}
