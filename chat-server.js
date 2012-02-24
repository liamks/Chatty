var io = require('socket.io').listen(5001);
var _ = require('underscore')._;
var users = {};

io.sockets.on('connection', function (socket) {
  var user;

  socket.emit('users-connected', _.values(users));

  socket.on('new-user', function (data) {
    user = data
    users[user.uuid] = data
    socket.broadcast.emit('new-user-connected', data);
  });

  socket.on('message', function(msgInfo){
    msgInfo.isFromMe = false;
    socket.broadcast.emit('receieve-message', msgInfo);
  });

  socket.on('disconnect', function(){
    if(user){
      delete users[user.uuid];
      socket.broadcast.emit('user-disconnected', user);
    };
  })
});