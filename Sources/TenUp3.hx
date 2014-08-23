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
import kha.Key;
import kha.Loader;
import kha.LoadingScreen;
import kha.math.Matrix3;
import kha.Music;
import kha.Scaler;
import kha.Scene;
import kha.Score;
import kha.Configuration;
import kha.ScreenRotation;
import kha.Storage;
import kha.Tile;
import kha.Tilemap;

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
		Localization.language = Localization.LanguageType.en; // TODO: language select
		Localization.init("text");
		backbuffer = Image.createRenderTarget(400, 300);
		font = Loader.the.loadFont("Arial", new FontStyle(false, false, false), 12);
		startGame();
	}
	
	public function startGame() {
		getHighscores().load(Storage.defaultFile());
		Player.init();
		player = new PlayerProfessor(10, 10);
		Scene.the.addHero(player);
		
		if (Gamepad.get(0) != null) Gamepad.get(0).notify(axisListener, buttonListener);
		
		Dialogues.setStartDlg(player, player);
		
		Configuration.setScreen(this);
	}
	
	public override function update() {
		super.update();
		switch (mode) {
		case Game:
			Scene.the.camx = Std.int(player.x) + Std.int(player.width / 2);
		case BlaBlaBla:
			Dialogue.update();
		}
		Scene.the.camy = Std.int(player.y) + Std.int(player.height / 2);
	}
	
	public override function render(frame: Framebuffer) {
		var g = backbuffer.g2;
		g.begin();
		scene.render(g);
		BlaBox.render(g);
		Inventory.render(g);
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

	override public function buttonDown(button : Button) : Void {
		switch (mode) {
		case Game:
			switch (button) {
			case UP, BUTTON_1, BUTTON_2:
				player.setUp();
			case LEFT:
				player.left = true;
			case RIGHT:
				player.right = true;
			default:
			}
		default:
		}
	}
	
	override public function buttonUp(button : Button) : Void {
		switch (mode) {
		case Game:
			switch (button) {
			case UP, BUTTON_1, BUTTON_2:
				player.up = false;
			case LEFT:
				player.left = false;
			case RIGHT:
				player.right = false;
			default:
			}
		case BlaBlaBla:
			switch (button) {
			case BUTTON_1, BUTTON_2:
				Dialogue.next();	
			default:
			}
		default:
		}
	}
	
	override public function keyDown(key: Key, char: String) : Void {
		
	}
	
	override public function keyUp(key : Key, char : String) : Void {
		if (key != null && key == Key.SHIFT) shiftPressed = false;
	}

	public override function mouseDown(x: Int, y: Int): Void {
		mouseX = x / 2 + Scene.the.screenOffsetX;
		mouseY = y / 2 + Scene.the.screenOffsetY;
		player.useSpecialAbilityA();
	}
	
	public override function mouseUp(x: Int, y: Int): Void {
		mouseX = x / 2 + Scene.the.screenOffsetX;
		mouseY = y / 2 + Scene.the.screenOffsetY;
		if (mode == BlaBlaBla) {
			Dialogue.next();
		}
	}
	
	public override function mouseMove(x: Int, y: Int): Void {
		mouseX = x / 2 + Scene.the.screenOffsetX;
		mouseY = y / 2 + Scene.the.screenOffsetY;
	}
}
