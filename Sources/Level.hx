package;

import haxe.io.Bytes;
import kha.Blob;
import kha.Color;
import kha.Configuration;
import kha.Game;
import kha.Loader;
import kha.LoadingScreen;
import kha.math.Vector2i;
import kha.Scene;
import kha.Sprite;
import kha.Storage;
import kha.Tile;
import kha.Tilemap;

class Level {
	public static var solution : Bool = false;
	private static var levelName: String;
	private static var done: Void -> Void;
	public static var tilemap: Tilemap;
	public static var liquids: Tilemap;
	private static var levelWidth: Int;
	private static var levelHeight: Int;
	
	public static function load(levelName: String, done: Void -> Void): Void {
		Level.levelName = levelName;
		Level.done = done;
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom(levelName, initLevel);
	}
	
	public static function getSaveMap(): Array<Array<Int>> {
		var map = new Array<Array<Int>>();
		for (x in 0...levelWidth) {
			map.push(new Array<Int>());
			for (y in 0...levelHeight) {
				map[x].push(liquids.get(x, y));
			}
		}
		return map;
	}
	
	private static function initLevel(): Void {
		//Storage.defaultFile().write(null);
		Cfg.init();
		
		var tileColissions = new Array<Tile>();
		for (i in 0...600) {
			tileColissions.push(new Tile(i, isCollidable(i)));
		}
		var blob = Loader.the.getBlob(levelName);
		blob.reset();
		levelWidth = blob.readS32BE();
		levelHeight = blob.readS32BE();
		var originalmap = new Array<Array<Int>>();
		for (x in 0...levelWidth) {
			originalmap.push(new Array<Int>());
			for (y in 0...levelHeight) {
				originalmap[x].push(blob.readS32BE());
			}
		}
		var map = new Array<Array<Int>>();
		for (x in 0...originalmap.length) {
			map.push(new Array<Int>());
			for (y in 0...originalmap[0].length) {
				map[x].push(0);
			}
		}
		var spriteCount = blob.readS32BE();
		var sprites = new Array<Int>();
		for (i in 0...spriteCount) {
			sprites.push(blob.readS32BE());
			sprites.push(blob.readS32BE());
			sprites.push(blob.readS32BE());
		}
		
		Scene.the.clear();
		Scene.the.setBackgroundColor(Color.fromBytes(255, 255, 255));
		
		var liquidMap = new Array<Array<Int>>();
		if (Cfg.getVictoryCondition(VictoryCondition.WATER)) {
			for (x in 0...levelWidth) {
				liquidMap.push(new Array<Int>());
				for (y in 0...levelHeight) {
					liquidMap[x].push(isCollidable(originalmap[x][y]) ? 0 : 1);
				}
			}
			for (x in 0...levelWidth) {
				for (y in 0...levelHeight) {
					if (liquidMap[x][y] == 1) {
						if (y == 14) liquidMap[x][y] = 3;
						else if (y > 14) liquidMap[x][y] = 17;
					}
				}
			}
		}
		else if (Cfg.getMap() != null) {
			liquidMap = Cfg.getMap();
		}
		else {
			for (x in 0...levelWidth) {
				liquidMap.push(new Array<Int>());
				for (y in 0...levelHeight) {
					liquidMap[x].push(isCollidable(originalmap[x][y]) ? 0 : 1);
				}
			}
		}
		
		#if JUST_A_NORMAL_DAY
			for (x in 0...levelWidth) {
				for (y in 0...levelHeight) {
					if (Lava.isLava(liquidMap[x][y])) {
						liquidMap[x][y] += 18;
					}
				}
			}
		#end
		
		var liquidTiles = new Array<Tile>();
		for (i in 0...100) liquidTiles.push(new LiquidTile(i));
		liquids = new Tilemap("liquids", 32, 32, liquidMap, liquidTiles);
		
		//var tileset = "sml_tiles";
		//if (levelName == "level1") tileset = "tileset1";
		var tileset = "outside";
		
		tilemap = new Tilemap(tileset, 32, 32, map, tileColissions);
		Scene.the.setColissionMap(liquids);
		Scene.the.addBackgroundTilemap(tilemap, 1);
		Scene.the.addForegroundTilemap(liquids, 1);
		var TILE_WIDTH : Int = 32;
		var TILE_HEIGHT : Int = 32;
		for (x in 0...originalmap.length) {
			for (y in 0...originalmap[0].length) {
				switch (originalmap[x][y]) {
				default:
					map[x][y] = originalmap[x][y];
				}
			}
		}
		//var jmpMan = Jumpman.getInstance();
		for (i in 0...spriteCount) {
			var sprite: kha.Sprite;
			var x = sprites[i * 3 + 1];
			var y = sprites[i * 3 + 2];
			if (levelName == "level1") {
				x *= 2;
				y *= 2;
			}
			switch (sprites[i * 3]) {
			case 0: // Eheweib
				sprite = new Sprite(Loader.the.getImage("eheweib"));
				sprite.x = x;
				sprite.y = y;
				sprite.accy = 0;
				Cfg.eheweib = sprite;
				Scene.the.addEnemy(sprite);
			case 1: // Mann
				if (Cfg.mann == null) {
					Cfg.mann = new ZeroEightFifteenMan(x, y);
				}
				Cfg.mannPositions.push(new Vector2i(x, y));
			case 2: // Verkaeuferin
				if (Cfg.verkaeuferin == null) {
					Cfg.verkaeuferin = new Verkaeuferin(x, y);
				}
				Cfg.verkaeuferinPositions.push(new Vector2i(x, y));
			/*case 3: // door
				sprite = new Door(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				Scene.the.addOther(sprite);*/
			/*case 4: // theke
				*/
			/*case 5: // backdoor
				sprite = new Door(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				Scene.the.addOther(sprite);*/
			case 6: // mafioso
				Cfg.mafioso = new Mafioso(x, y);
				Scene.the.addEnemy(Cfg.mafioso);
			case 7: // machine gun
				// Integrated into mafioso
			case 8:
				sprite = new TenUpShelf(x, y);
				Scene.the.addEnemy(sprite);
			default:
				trace("That should never happen! We are therefore going to ignore it.");
				continue;
			}
		}
		
		Configuration.setScreen(TenUp3.getInstance());
		done();
	}
	
	private static function isCollidable(tilenumber : Int) : Bool {
		switch (tilenumber) {
		case 64, 65, 66, 128, 320, 341, 342, 346, 347: return true;
		default:
			return false;
		}
	}
}
