package;

import kha.Loader;
import kha.Sprite;

class FlowCan extends Sprite {
	public var can: String;
	
	public function new(can: String) {
		super(Loader.the.getImage(can));
		this.can = can;
	}
}
