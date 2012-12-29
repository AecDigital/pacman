/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Main game character implementation (pacman), also handles user moves.
*/

package contingutsMultimedia {

	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import contingutsMultimedia.Actor;
	import flash.display.MovieClip;
	import contingutsMultimedia.Mapa;
	import contingutsMultimedia.Item;


	// Pacman player :-)
	public class Pacman extends Actor {

		// Constants
		public static const STARTSPEED:Number = 5;

		// Real direction where pacman moves
		private var _realDirection:Point;

		// Constructor
		public function Pacman(pacmanGraphicsClip:String, m:Mapa, startPosition:Point){
			_realDirection = new Point(1,0);
			map = m;
			var definedImplementation:Class = getDefinitionByName(pacmanGraphicsClip) as Class;
      		var pacmanClip:MovieClip = new definedImplementation();
			super(pacmanClip, STARTSPEED, new Point(1,0), startPosition);

		}

		// Act player
		public function actuate(){
			
			// Eat current item
			map.eatItemAt(_position);

			// Check next tile based on next position
			var nextTile:Item = map.getTileAtPoint(_position.x + _moveDirection.x, _position.y + _moveDirection.y);
			var nextTileR:Item = map.getTileAtPoint(_position.x + _realDirection.x, _position.y + _realDirection.y);
			
			// Avoid movement change to hit a wall, this disables pacman to stop in the middle of a corridor
			if((_realDirection.x != _moveDirection.x) || (_realDirection.y != _moveDirection.y)){
				if( pacmanCanMove(nextTile.getType()) ){
					nextTileR = nextTile;
					_realDirection.x = _moveDirection.x;
					_realDirection.y = _moveDirection.y;
				}
			}
			
			// If tile is not a wall, stand still
			if( pacmanCanMove(nextTileR.getType()) ){
				
				//Check direction to avoid "cornering" effect
				if(_realDirection.y == 0){
					_deltaChange.x += _speed * _realDirection.x;
					_deltaChange.y = 0;
				}
				if(_realDirection.x == 0){
					_deltaChange.y += _speed * _realDirection.y;
					_deltaChange.x = 0;
				}

				// Update head position
				pacmanMoveHead(_realDirection);

				// Check if delta causes a tileChange and update pacman position on map
				if(Math.abs(_deltaChange.x) >= map.getTileSize()){
					_deltaChange.x = 0;
					_deltaChange.y = 0;
					moveActor(_realDirection);
				}
				if(Math.abs(_deltaChange.y) >= map.getTileSize()){
					_deltaChange.x = 0;
					_deltaChange.y = 0;
					moveActor(_realDirection);
				}
			}

			// change our position
			this.updateRealMapPosition();
		}

		public function pacmanMoveHead(moveDirection){
			if(moveDirection.equals(Constants.UP)){
				_graphicsImplement.gotoAndStop(1);
			}else if(moveDirection.equals(Constants.DOWN)){
				_graphicsImplement.gotoAndStop(2);
			}else if(moveDirection.equals(Constants.LEFT)){
				_graphicsImplement.gotoAndStop(3);
			}else{
				_graphicsImplement.gotoAndStop(4);
			}
		}

		public function pacmanCanMove(item:String){
			if(item != Constants.WALL && item != Constants.JAILDOOR){
				return true;
			}
			return false;
		}
	}
}