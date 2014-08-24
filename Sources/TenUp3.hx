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
	
	var player: PlayerProfessor;
	
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
		Dialogues.init();
		Inventory.init();
		
		switch(subgame) {
		case SubGame.TEN_UP_3:
			startGame_TenUp3();
		case SubGame.JUST_A_NORMAL_DAY:
			startGame_JustANormalDay();
		}
		if (Gamepad.get(0) != null) Gamepad.get(0).notify(axisListener, buttonListener);
		Keyboard.get().notify(keydown, keyup);
		
		Configuration.setScreen(this);
	}
	
	private var waterflow: Sprite;
	private var lavaflow: Sprite;
	private var gasflow: Sprite;
	private var noflow: Sprite;
	
	public function startGame_TenUp3() {
		Player.init();
		player = new PlayerProfessor(400, 10);
		Scene.the.addHero(player);
		Inventory.pick(waterflow = new FlowCan('waterflow'));
		Inventory.pick(lavaflow = new FlowCan('lavaflow'));
		Inventory.pick(gasflow = new FlowCan('gasflow'));
		Inventory.pick(noflow = new FlowCan('noflow'));
		Dialogues.startProfStartDialog(player);
	}
	
	public function startGame_JustANormalDay() {
		Player.init();
		player = new PlayerProfessor(250, 400);
		Scene.the.addHero(player);
		
		var euro = new Sprite(Loader.the.getImage("euro"));
		var cent = new Sprite(Loader.the.getImage("cent"));
		Inventory.pick(euro);
		Inventory.pick(cent);
		
		var eheweib = new Sprite(null, 25, 25);
		eheweib.x = 150;
		eheweib.y = 300;
		eheweib.accy = 0;
		Scene.the.addEnemy(eheweib);
		
		//Dialogues.setStartDlg(player, eheweib);
		//Dialogues.setVerkaufMannDlg(player, eheweib, null, null, null);
		Dialogues.setTestDlg(player, eheweib, eheweib, null, null, null);
	}
	
	public override function update() {
		super.update();
		Scene.the.camx = Std.int(player.x) + Std.int(player.width / 2);
		switch (subgame) {
			case TEN_UP_3:
				Scene.the.camy = Std.int(player.y) + Std.int(player.height / 2);
			case JUST_A_NORMAL_DAY:
				Scene.the.camy = Std.int(player.y - 0.35 * height) + Std.int(player.height / 2);
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
						Inventory.select(waterflow);
					}
					else if (char == '2') {
						Inventory.select(lavaflow);
					}
					else if (char == '3') {
						Inventory.select(gasflow);
					}
					else if (char == '4') {
						Inventory.select(noflow);
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

	public override function mouseDown(x: Int, y: Int): Void {
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
	
	public override function mouseUp(x: Int, y: Int): Void {
		mouseX = x + Scene.the.screenOffsetX;
		mouseY = y + Scene.the.screenOffsetY;
		if (mode == BlaBlaBla) {
			Dialogue.next();
		}
	}
	
	public override function mouseMove(x: Int, y: Int): Void {
		mouseX = x + Scene.the.screenOffsetX;
		mouseY = y + Scene.the.screenOffsetY;
	}
}
