var processingInstance;
var socket;
var users = [];

(function waitPJS() { 
  processingInstance = Processing.getInstanceById('engine');

  if (processingInstance) {
    socket = io.connect('http://' + document.domain + ':' + location.port, {transports: ['websocket'], secure: false, 'force new connection': false, 'reconnect': true});
    socket.on('onconnected', function(cSid) {
      console.log('Client: ' + cSid + ' connected...');
      socket.emit('joined', {client_sid: cSid});
    });

    socket.on('send joined users', function(curr_users) {
      users = curr_users;
    });

    socket.on('send updated users', function(updated_users) {
      users = updated_users;
    });

    socket.on('send updated user pos', function(updated_users) {
      users = updated_users;
    });

    console.log('Processing engine instance retrieved...');

  } else {
    setTimeout(waitPJS, 1000);
  }

})();

