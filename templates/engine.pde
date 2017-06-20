int currX = 50;
int currY = 50;

boolean isLeft, isRight, isDown, isUp;

void setup() {
  size(800, 800);
  strokeWeight(10);
  frameRate(30);
}

void draw() {
  background(100);
  createPlayers();
}

void createPlayers() {
  if(users.length > 0) {
    for(int i = 0; i < users.length; i++;) {
      socket.emit('update other users');
      if (users[i].sid === socket.io.engine.id) {
        move(users[i]);
        fill(80, 230, 50);
        rect(currX, currY, 35, 35, 10);
      } else {
        fill(80, 230, 50);
        rect(users[i].X, users[i].Y, 35, 35, 10);
      }
    }
  }
}

void keyPressed() {
  if (key == 'w') {
    isUp = true;
  }
  if (key == 's') {
    isDown = true;
  }
  if (key == 'a') {
    isLeft = true;
  }
  if (key == 'd') {
    isRight = true;
  }
}

void keyReleased() {
  if (isUp) {
    isUp = false;
  }
  if (isDown) {
    isDown = false;
  }
  if (isLeft) {
    isLeft = false;
  }
  if (isRight) {
    isRight = false;
  }
}

void move(user) {
  console.log("isUp: " + isUp + " isDown: " + isDown + " isLeft: " +  isLeft + " isRight: " + isRight);
  if (isUp) {
    currY -= 5;
    user.Y = currY;
    socket.emit('update user pos', [user.sid, user.X, currY, "UP"]); 
  }
  if (isDown) {
    currY += 5;
    user.Y = currY;
    socket.emit('update user pos', [user.sid, user.X, currY, "DOWN"]);
  }
  if (isLeft) {
    currX -= 5;
    user.X = currX;
    socket.emit('update user pos', [user.sid, user.X, currY, "LEFT"]);
  }
  if (isRight) {
    currX += 5;
    user.X = currX;
    socket.emit('update user pos', [user.sid, user.X, currY, "RIGHT"]);
  }
  if (isDown && isRight) {
    currX += 5;
    currY += 5;
    user.X = currX;
    user.Y = currY;
    socket.emit('update user pos', [user.sid, user.X, currY, "DOWNRIGHT"]);
  }
  if (isDown && isLeft) {
    currX -= 5;
    currY += 5;
    user.X = currX;
    user.Y = currY;
    socket.emit('update user pos', [user.sid, user.X, currY, "DOWNLEFT"]);
  }
  if (isUp && isRight) {
    currX += 5;
    currY -= 5;
    user.X = currX;
    user.Y = currY;
    socket.emit('update user pos', [user.sid, user.X, currY, "UPRIGHT"]);
  }
  if (isUp && isLeft) {
    currX -= 5;
    currY -= 5;
    user.X = currX;
    user.Y = currY;
    socket.emit('update user pos', [user.sid, user.X, currY, "UPLEFT"]);
  }
}
