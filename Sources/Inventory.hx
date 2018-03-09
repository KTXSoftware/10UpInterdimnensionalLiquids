package;

import kha.Animation;
import kha.Color;
import kha.Game;
import kha.graphics2.Graphics;
import kha.Loader;
import kha.math.Vector2;
import kha.Scene;
import kha.Sprite;

class Inventory {
	var y : Float;
	public var itemWidth : Int = 48;
	public var spacing(default, set) = 15;
	public var itemHeight(default, set) : Int = 48;
	var items : Array<Sprite> = new Array();
	var selected : Int = -1;
	var offset : Int = 0;
	
	function set_spacing(value: Int) : Int {
		y = Game.the.height - itemHeight - 2 * value;
		if (Player.current() != null && Player.current().inventory == this) {
			Scene.the.camyHack = itemHeight + 2 * value;
		}
		return spacing = value;
	}
	function set_itemHeight(value: Int) : Int {
		y = Game.the.height - value - 2 * spacing;
		if (Player.current() != null && Player.current().inventory == this) {
			Scene.the.camyHack = value + 2 * spacing;
		}
		return itemHeight = value;
	}
	
	public function new() {
		items = new Array();
		selected = -1;
		y = Game.the.height - itemHeight - 2 * spacing;
	}
	
	public function isEmpty() : Bool {
		return items.length == 0;
	}
	
	public function pick(item : Sprite) {
		items.push(item);
	}
	
	public function loose(item : Sprite) {
		items.remove(item);
	}
	
	public function selectedIndex(): Int {
		return selected;
	}
	
	public function selectIndex(index: Int): Void {
		selected = index;
	}
	
	public function select(item : Sprite) {
		var s = items.indexOf(item);
		if (s == selected) {
			selected = -1;
		} else {
			selected = s;
		}
	}
	
	public function getSelectedItem() : Sprite {
		return (selected >= 0 && selected < items.length) ? items[selected] : null;
	}
	
	public function getItemBelowPoint(px : Int, py : Int) : Sprite {
		var pos : Int = -1;
		if ( y <= py && py <= y + spacing + itemHeight ) {
			px -= spacing;
			while (px >= 0) {
				pos += 1;
				px -= itemWidth;
				if (px < 0) {
					if (pos >= 0 && pos < items.length) {
						return items[pos];
					} else {
						return null;
					}
				}
				px -= 2 * spacing;
			}
			pos = -1;
		}
		return null;
	}
	
	public function render(g : Graphics) {
		var itemX = spacing;
		var itemY = y + spacing;
		g.color = Color.Black;
		g.fillRect(0, y, Game.the.width, itemHeight + 2 * spacing);
		for (i in offset...items.length) {
			var item = items[i];
			item.x = itemX;
			item.y = itemY;
			var osx = item.scaleX;
			var osy = item.scaleY;
			item.scaleX *= itemWidth / item.width;
			item.scaleY *= itemHeight / item.height;
			item.render(g);
			item.scaleX = osx;
			item.scaleY = osy;
			if (i == selected) {
				g.color = Color.fromValue(0xFFFF00FF);
				var top = itemY - 1;
				var bottom = itemY + itemHeight + 1;
				var left = itemX;
				var right = itemX + itemWidth + 1;
				g.drawLine( left, top, right, top, 3);
				g.drawLine( left, top, left, bottom, 3);
				g.drawLine( left, bottom, right, bottom, 3);
				g.drawLine( right, top, right, bottom, 3);
			}
			itemX += itemWidth + 2 * spacing;
		}
	}
}
