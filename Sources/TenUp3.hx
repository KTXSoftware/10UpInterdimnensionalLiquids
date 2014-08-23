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
	Highscore;
	EnterHighscore;
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
		backbuffer = Image.createRenderTarget(400, 300);
		font = Loader.the.loadFont("Arial", new FontStyle(false, false, false), 12);
		/*tileColissions = new Array<Tile>();
		for (i in 0...140) {
			tileColissions.push(new Tile(i, isCollidable(i)));
		}
		var blob = Loader.the.getBlob("level.map");
		var levelWidth: Int = blob.readS32BE();
		var levelHeight: Int = blob.readS32BE();
		originalmap = new Array<Array<Int>>();
		for (x in 0...levelWidth) {
			originalmap.push(new Array<Int>());
			for (y in 0...levelHeight) {
				originalmap[x].push(blob.readS32BE());
			}
		}
		map = new Array<Array<Int>>();
		for (x in 0...originalmap.length) {
			map.push(new Array<Int>());
			for (y in 0...originalmap[0].length) {
				map[x].push(0);
			}
		}
		music = Loader.the.getMusic("level1");*/
		startGame();
	}
	
	public function startGame() {
		getHighscores().load(Storage.defaultFile());
		Player.init();
		player = new PlayerProfessor(10, 10);
		/*Scene.the.clear();
		Scene.the.setBackgroundColor(Color.fromBytes(255, 255, 255));
		var tilemap : Tilemap = new Tilemap("sml_tiles", 32, 32, map, tileColissions);
		Scene.the.setColissionMap(tilemap);
		Scene.the.addBackgroundTilemap(tilemap, 1);
		var TILE_WIDTH : Int = 32;
		var TILE_HEIGHT : Int = 32;
		for (x in 0...originalmap.length) {
			for (y in 0...originalmap[0].length) {
				switch (originalmap[x][y]) {
				case 15:
					map[x][y] = 0;
					Scene.the.addEnemy(new Gumba(x * TILE_WIDTH, y * TILE_HEIGHT));
				case 16:
					map[x][y] = 0;
					Scene.the.addEnemy(new Koopa(x * TILE_WIDTH, y * TILE_HEIGHT - 16));
				case 17:
					map[x][y] = 0;
					Scene.the.addEnemy(new Fly(x * TILE_WIDTH - 32, y * TILE_HEIGHT - 8));
				case 46:
					map[x][y] = 0;
					Scene.the.addEnemy(new Coin(x * TILE_WIDTH, y * TILE_HEIGHT));
				case 52:
					map[x][y] = 52;
					Scene.the.addEnemy(new Exit(x * TILE_WIDTH, y * TILE_HEIGHT));
				case 56:
					map[x][y] = 1;
					Scene.the.addEnemy(new BonusBlock(x * TILE_WIDTH, y * TILE_HEIGHT));
				default:
					map[x][y] = originalmap[x][y];
				}
			}
		}
		music.play(true);*/
		Scene.the.addHero(player);
		
		if (Gamepad.get(0) != null) Gamepad.get(0).notify(axisListener, buttonListener);
		
		Configuration.setScreen(this);
	}
	
	public function showHighscore() {
		Scene.the.clear();
		mode = Mode.EnterHighscore;
		music.stop();
	}
	
	private static function isCollidable(tilenumber : Int) : Bool {
		switch (tilenumber) {
		case 1: return true;
		case 6: return true;
		case 7: return true;
		case 8: return true;
		case 26: return true;
		case 33: return true;
		case 39: return true;
		case 48: return true;
		case 49: return true;
		case 50: return true;
		case 53: return true;
		case 56: return true;
		case 60: return true;
		case 61: return true;
		case 62: return true;
		case 63: return true;
		case 64: return true;
		case 65: return true;
		case 67: return true;
		case 68: return true;
		case 70: return true;
		case 74: return true;
		case 75: return true;
		case 76: return true;
		case 77: return true;
		case 84: return true;
		case 86: return true;
		case 87: return true;
		default:
			return false;
		}
	}
	
	public override function update() {
		super.update();
		Scene.the.camx = Std.int(player.x) + Std.int(player.width / 2);
	}
	
	public override function render(frame: Framebuffer) {
		var g = backbuffer.g2;
		g.begin();
		scene.render(g);
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
		default:
		}
	}
	
	override public function keyDown(key: Key, char: String) : Void {
		
	}
	
	override public function keyUp(key : Key, char : String) : Void {
		if (key != null && key == Key.SHIFT) shiftPressed = false;
	}

	public override function mouseDown(x: Int, y: Int): Void {
		
	}
	
	public override function mouseUp(x : Int, y : Int) : Void {
		
	}
}
