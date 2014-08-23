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
		
		//var tileset = "sml_tiles";
		//if (levelName == "level1") tileset = "tileset1";
		var tileset = "outside";
		
		var tilemap : Tilemap = new Tilemap(tileset, 16, 16, map, tileColissions);
		Scene.the.setColissionMap(tilemap);
		Scene.the.addBackgroundTilemap(tilemap, 1);
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
		if (levelName == "level1") {
			switch (tilenumber) {
				case 33, 34, 35, 36, 48, 49, 50, 96, 97, 98, 99, 100, 101: return true;
				default: return false;
			}
		}
		else {
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
	}
}
