package {
	import flash.display.MovieClip;
	import flash.events.*;
	public class Car extends MovieClip {
		public var velocity: Number; 
		
		//DRIVING STATES
		public var isMovingForward: Boolean;
		public var isMovingReverse: Boolean;
		public var isTurningLeft: Boolean;
		public var isTurningRight: Boolean;
		public var isBraking: Boolean;
		public var cornerDist: Number;
		public var thetaRadians:Number;
		
		
		public function Car(xPos, yPos: Number) {
			this.x = xPos;
			this.y = yPos;
			velocity = 0; 
			cornerDist = 0;
			thetaRadians = 0;
			
			//ALL DRIVING STATES ARE INITIALLY SET TO FALSE
			isMovingForward = false;
			isMovingReverse = false;
			isTurningLeft = false;
			isTurningRight = false;
			isBraking = false; //LOOP EVENT FOR MOVING THE CAR
			addEventListener(Event.ENTER_FRAME, driveCar);
			
		}
		public function driveCar(event: Event) {
			//TASK 1: USER SPECIFIES MOVEMENT IN VELOCITY
			if (isMovingForward) {
				if (velocity > Game.MAX_VELOCITY) {
					velocity += Game.ACCELERATION;
				}
			} else if (isMovingReverse) {
				if (velocity < Game.MAX_REVERSE_VELOCITY) {
					velocity += Game.REVERSE;
				}
			} else {
				velocity *= Game.DECELERATION;
			} 
		
			//TASK 2: USER SPECIFIES TURNING
			if (isTurningRight) {
				this.rotation += Game.TURN;
			} else if (isTurningLeft) {
				rotation -= Game.TURN;
			}

			//TASK 3: USER SPECIFIES BRAKING
			if (isBraking) {
				applyBrake();
			}
		}
	
		public function applyBrake() {
			if ((velocity < Game.MIN_VELOCITY)) {
				velocity *= Game.BRAKE;
			} else {
				velocity = 0;
			}
		}
	}
}