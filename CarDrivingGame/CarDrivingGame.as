package {
	import flash.events.*;
	import flash.display.*;
	import flash.utils.*;
	import flash.geom.Point;

	public class CarDrivingGame extends MovieClip {
		//GAME ELEMENTS
		private var car: Car;
		private var lastTimeStamp: uint;
		private var carWidth: int;
		private var carHeight: int;
		private var antL: Antenna;
		private var antR: Antenna;
		public function CarDrivingGame() {
			//TASK 1: ADD THE CAR TO THE STAGE
			car = new Car(track.x, track.y);
			addChild(car);
			car.rotation = 0;
			antL = new Antenna(track.x + 12, track.y - 32);
			//antL = new Antenna(car.x, car.y);
			antR = new Antenna(track.x - 12, track.y - 32);
			addChild(antL);
			addChild(antR);
			car.isMovingForward = true;

			// TASK 2: REGISTER KEYBOARD EVENTS FOR KEY DOWN
			// NOTE: USING BOTH EVENTS, USERS CAN TURN AND ACCELERATE SIMULTANEUSLY
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownFunction);
			//stage.addEventListener(KeyboardEvent.KEY_UP, keyUpFunction);
			//TASK 3: REGISTER LISTENER EVENT FOR THE GAME LOOP
			lastTimeStamp = getTimer();
			addEventListener(Event.ENTER_FRAME, updateCameraAngle);
		}

		public function updateCameraAngle(event: Event) {
			carWidth = car.width;
			carHeight = car.height;
			//maybe /2?
			//trace(carWidth, carHeight);

			//TASK 1: COMPUTE ELAPSED TIME
			var elapsedTime: int = getTimer() - lastTimeStamp;
			lastTimeStamp += elapsedTime;
			// TASK 2: CHANGE THE CAMERA ANGLE
			var toRadians: Number = Math.PI / 180;
			track.x += car.velocity * Math.sin(car.rotation * toRadians) * elapsedTime / 100;
			track.y -= car.velocity * Math.cos(car.rotation * toRadians) * elapsedTime / 100;

			
			/*
			//antenna
			var sensorDistance:Number = Math.sqrt( (carWidth *carWidth)  + (carHeight*carHeight) ) + 10;
			//trace(sensorDistance);
			//trace(car.rotation);
			var theta:Number = Math.atan( (carHeight/2) / (carWidth/2)) * toRadians;
			//add car.x and car.y
			antL.x = car.x + sensorDistance * Math.cos(Math.PI - theta + (car.rotation * toRadians));
			antL.y = car.y - sensorDistance * Math.sin(Math.PI - theta + (car.rotation * toRadians));
			antR.x = car.x + sensorDistance * Math.cos(theta + (car.rotation * toRadians)) ;
			antR.y = car.y - sensorDistance * Math.sin(theta + (car.rotation * toRadians)) ;
			*/
			
			var rotateAngleRadians: Number = car.rotation * toRadians;
			var carHyp:Number = Math.sqrt(15*15 + 30*30);
			car.cornerDist = carHyp + 10;
			var thetaRadians = Math.atan2(60.0/2, 30.0/2);
			car.thetaRadians = thetaRadians;
			var alphaDegrees = -1*car.rotation;
			var alphaRadians:Number = alphaDegrees * 3.14159/180;
			var xPos = car.x + car.cornerDist*Math.cos(thetaRadians + alphaRadians);
			var yPos = car.y - car.cornerDist*Math.sin(thetaRadians + alphaRadians);
			antR.x = xPos;
			antR.y = yPos;
			xPos = car.x + car.cornerDist*Math.cos(Math.PI - thetaRadians + alphaRadians);
			yPos = car.y - car.cornerDist*Math.sin(Math.PI - thetaRadians + alphaRadians);
			antL.x = xPos;
			antL.y = yPos;
			
			
			
			
			
			//speedometer
			speedometer.needle.rotation = car.velocity * -9.5;
			if (car.isMovingReverse) {
				speedometer.needle.rotation *= -1;
			}
			if (track.hitTestPoint(car.x, car.y, true)) {
				car.velocity *= Game.SLOW;
			}
			//AI
			
			if (track.hitTestPoint(antL.x, antL.y, true)) {
				car.isTurningLeft = false;
				car.isTurningRight = true;
				//trace("meow");
			} else if (track.hitTestPoint(antR.x, antR.y, true)) {
				car.isTurningRight = false;
				car.isTurningLeft = true;
				//trace("bark");
			} else if (!track.hitTestPoint(antL.x, antL.y, true)) {
				car.isTurningRight = false;
				car.isTurningLeft = false;
				//trace("cheep");
			} else if (!track.hitTestPoint(antR.x, antR.y, true)) {
				car.isTurningRight = false;
				car.isTurningLeft = false;
					//trace("bah");
				}
		
		}

		//****************** KEYBOARD EVENT METHODS ********************************
		public function keyDownFunction(event: KeyboardEvent) {
			//FINITE STATES ACCELERATION, REVERSE, TURNING, BRAKING
			switch (event.keyCode) {
				case Game.UPARROW:
					car.isMovingForward = true;
					break;
				case Game.DOWNARROW:
					car.isMovingReverse = true;
					break;
				case Game.LEFTARROW:
					car.isTurningLeft = true;
					break;
				case Game.RIGHTARROW:
					car.isTurningRight = true;
					break;
				case Game.SPACEBAR:
					car.isBraking = true;
			}
		}

		public function keyUpFunction(event: KeyboardEvent) {
			switch (event.keyCode) {
				case Game.UPARROW:
					car.isMovingForward = false;
					break;
				case Game.DOWNARROW:
					car.isMovingReverse = false;
					break;
				case Game.LEFTARROW:
					car.isTurningLeft = false;
					break;
				case Game.RIGHTARROW:
					car.isTurningRight = false;
					break;
				case Game.SPACEBAR:
					car.isBraking = false;
			}
		}
	}
}