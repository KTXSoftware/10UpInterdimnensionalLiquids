package;

import kha.Color;
import kha.Configuration;
import kha.Game;
import kha.Loader;
import kha.LoadingScreen;
import kha.Scene;
import kha.Tile;
import kha.Tilemap;

class Level {
	public static var solution : Bool = false;
	private static var levelName: String;
	private static var done: Void -> Void;
	public static var liquids: Tilemap;
	
	public static function load(levelName: String, done: Void -> Void): Void {
		Level.levelName = levelName;
		Level.done = done;
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom(levelName, initLevel);
	}
	
	private static function initLevel(): Void {
		var tileColissions = new Array<Tile>();
		for (i in 0...600) {
			tileColissions.push(new Tile(i, isCollidable(i)));
		}
		var blob = Loader.the.getBlob(levelName);
		blob.reset();
		var levelWidth: Int = blob.readS32BE();
		var levelHeight: Int = blob.readS32BE();
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
		for (x in 0...levelWidth) {
			liquidMap.push(new Array<Int>());
			for (y in 0...levelHeight) {
				liquidMap[x].push(isCollidable(originalmap[x][y]) ? 0 : 1);
			}
		}
		var liquidTiles = new Array<Tile>();
		for (i in 0...100) liquidTiles.push(new LiquidTile(i));
		liquids = new Tilemap("liquids", 16, 16, liquidMap, liquidTiles);
		
		//var tileset = "sml_tiles";
		//if (levelName == "level1") tileset = "tileset1";
		var tileset = "outside";
		
		var tilemap : Tilemap = new Tilemap(tileset, 16, 16, map, tileColissions);
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
			if (levelName == "level1") {
				sprites[i * 3 + 1] *= 2;
				sprites[i * 3 + 2] *= 2;
			}
			/*switch (sprites[i * 3]) {
			case 0: // helmet
				sprite = new Helmet(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				Scene.the.addHero(sprite);
			case 1: // mask
				sprite = new SurgicalMaskAndInjection(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				Scene.the.addHero(sprite);
			case 2: // Pizza
				sprite = new Pizza(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				Scene.the.addHero(sprite);
			case 3: // director
				if (solution) {
					sprite = new Director(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				} else if (jmpMan.hasHelmet) {
					sprite = new Drake(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				} else if (jmpMan.hasSurgicalMask) {
					sprite = new WoundedPerson(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				} else {
					throw "This should not happen. Therefore you shall not pass\n\n\n\\n\n\nthis line of code";
				}
				Scene.the.addHero(sprite);
			case 4: // door
				sprite = new Door(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				Scene.the.addOther(sprite);
			case 5: // assistant
				var guy : GuyWithExtinguisher;
				if (solution || jmpMan.hasSurgicalMask) {
					guy = new GuyWithExtinguisher(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				} else if (jmpMan.hasHelmet) {
					guy = new Knight(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				} else {
					throw "This should not happen. Therefore you shall not pass\n\n\n\\n\n\nthis line of code";
				}
				guy.spawnItem();
				Scene.the.addHero(guy);
			case 6: // coat
				sprite = new WinterCoat(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				Scene.the.addHero(sprite);
			case 7: // fire
				sprite = new Fire(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				Scene.the.addHero(sprite);
			case 8: // saw
				sprite = new BoneSaw(sprites[i * 3 + 1], sprites[i * 3 + 2]);
				Scene.the.addHero(sprite);
			default:
				trace("That should never happen! We are therefore going to ignore it.");
				continue;
			}*/
		}
		
		Configuration.setScreen(TenUp3.getInstance());
		done();
	}
	
	private static function isCollidable(tilenumber : Int) : Bool {
		switch (tilenumber) {
		case 64, 65, 66, 128, 320, 341, 342: return true;
		default:
			return false;
		}
	}
}
