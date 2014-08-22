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

class SuperMarioLand extends Game {
	static var instance : SuperMarioLand;
	var music : Music;
	var tileColissions : Array<Tile>;
	var map : Array<Array<Int>>;
	var originalmap : Array<Array<Int>>;
	var highscoreName : String;
	var shiftPressed : Bool;
	private var font: Font;
	private var backbuffer: Image;
	
	var mode : Mode;
	
	public function new() {
		super("SML", true);
		instance = this;
		shiftPressed = false;
		highscoreName = "";
		mode = Mode.Game;
	}
	
	public static function getInstance() : SuperMarioLand {
		return instance;
	}
	
	public override function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("level1", initLevel);
	}

	public function initLevel(): Void {
		backbuffer = Image.createRenderTarget(600, 520);
		font = Loader.the.loadFont("Arial", new FontStyle(false, false, false), 12);
		tileColissions = new Array<Tile>();
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
		music = Loader.the.getMusic("level1");
		startGame();
	}
	
	public function startGame() {
		getHighscores().load(Storage.defaultFile());
		if (Jumpman.getInstance() == null) new Jumpman(music);
		Scene.the.clear();
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
		music.play(true);
		Jumpman.getInstance().reset();
		Scene.the.addHero(Jumpman.getInstance());
		
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
		if (Jumpman.getInstance() == null) return;
		Scene.the.camx = Std.int(Jumpman.getInstance().x) + Std.int(Jumpman.getInstance().width / 2);
	}
	
	public override function render(frame: Framebuffer) {
		if (Jumpman.getInstance() == null) return;
		
		var g = backbuffer.g2;
		g.begin();
		g.font = font;
		switch (mode) {
		case Highscore:
			g.color = Color.White;
			g.fillRect(0, 0, width, height);
			g.color = Color.Black;
			var i: Int = 0;
			while (i < 10 && i < getHighscores().getScores().length) {
				var score: Score = getHighscores().getScores()[i];
				g.drawString(Std.string(i + 1) + ": " + score.getName(), 100, i * 30 + 100);
				g.drawString(" -           " + Std.string(score.getScore()), 200, i * 30 + 100);
				++i;
			}
		case EnterHighscore:
			g.color = Color.White;
			g.fillRect(0, 0, width, height);
			g.color = Color.Black;
			g.drawString("Enter your name", width / 2 - 100, 200);
			g.drawString(highscoreName, width / 2 - 50, 250);
		case Game:
			scene.render(g);
			g.transformation = Matrix3.identity();
			g.color = Color.Black;
			g.drawString("Score: " + Std.string(Jumpman.getInstance().getScore()), 20, 25);
			g.drawString("Round: " + Std.string(Jumpman.getInstance().getRound()), width - 100, 25);
		}
		g.end();
		
		startRender(frame);
		Scaler.scale(backbuffer, frame, kha.Sys.screenRotation);
		endRender(frame);
	}
	
	private function axisListener(axis: Int, value: Float): Void {
		switch (axis) {
			case 0:
				if (value < -0.2) {
					Jumpman.getInstance().left = true;
					Jumpman.getInstance().right = false;
				}
				else if (value > 0.2) {
					Jumpman.getInstance().right = true;
					Jumpman.getInstance().left = false;
				}
				else {
					Jumpman.getInstance().left = false;
					Jumpman.getInstance().right = false;
				}
		}
	}
	
	private function buttonListener(button: Int, value: Float): Void {
		switch (button) {
			case 0, 1, 2, 3:
				if (value > 0.5) Jumpman.getInstance().setUp();
				else Jumpman.getInstance().up = false;
			case 14:
				if (value > 0.5) {
					Jumpman.getInstance().left = true;
					Jumpman.getInstance().right = false;
				}
				else {
					Jumpman.getInstance().left = false;
					Jumpman.getInstance().right = false;
				}
			case 15:
				if (value > 0.5) {
					Jumpman.getInstance().right = true;
					Jumpman.getInstance().left = false;
				}
				else {
					Jumpman.getInstance().right = false;
					Jumpman.getInstance().left = false;
				}
		}
	}

	override public function buttonDown(button : Button) : Void {
		switch (mode) {
		case Game:
			switch (button) {
			case UP, BUTTON_1, BUTTON_2:
				Jumpman.getInstance().setUp();
			case LEFT:
				Jumpman.getInstance().left = true;
			case RIGHT:
				Jumpman.getInstance().right = true;
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
				Jumpman.getInstance().up = false;
			case LEFT:
				Jumpman.getInstance().left = false;
			case RIGHT:
				Jumpman.getInstance().right = false;
			default:
			}	
		default:
		}
	}
	
	override public function keyDown(key: Key, char: String) : Void {
		if (key == Key.CHAR) {
			if (mode == Mode.EnterHighscore) {
				if (highscoreName.length < 20) highscoreName += shiftPressed ? char.toUpperCase() : char.toLowerCase();
			}
		}
		else {
			if (highscoreName.length > 0) {
				switch (key) {
				case ENTER:
					getHighscores().addScore(highscoreName, Jumpman.getInstance().getScore());
					getHighscores().save(Storage.defaultFile());
					mode = Mode.Highscore;
				case BACKSPACE:
					highscoreName = highscoreName.substr(0, highscoreName.length - 1);
				default:
				}
			}
			if (key == SHIFT) shiftPressed = true;
		}
	}
	
	override public function keyUp(key : Key, char : String) : Void {
		if (key != null && key == Key.SHIFT) shiftPressed = false;
	}

	public override function mouseDown(x: Int, y: Int): Void {
		var xt = painterTransformMouseX(x, y);
		if (xt > width / 2) Jumpman.getInstance().setUp();
		else {
			if (xt < width / 4) Jumpman.getInstance().left = true;
			else Jumpman.getInstance().right = true;
		}
	}
	
	public override function mouseUp(x : Int, y : Int) : Void {
		Jumpman.getInstance().up = false;
		Jumpman.getInstance().left = false;
		Jumpman.getInstance().right = false;
	}
}
