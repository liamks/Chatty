class SocketModule
  constructor: () ->
    @addHandlers()


  addHandlers: () ->
    app.events.on 'connect-info',       @connect
    app.events.on 'screenName-entered', @registerUser
    app.events.on 'send-message',       @sendMessage


  connect: (info) =>
    @url = info.socketURL
    @id = info.id
    @socket = io.connect @url
    @addSocketHandlers()

  registerUser: (screenName) =>
    @socket.emit 'new-user',
      screenName: screenName
      id:       @id

  sendMessage: (msgInfo) =>
    @socket.emit 'message', msgInfo

  addSocketHandlers: () ->
    @socket.on 'users-connected',     @usersConnected
    @socket.on 'new-user-connected',  @newUserConnected 
    @socket.on 'user-disconnected',   @userDisconnected
    @socket.on 'receieve-message',             @message

  usersConnected: (usersConnected) =>
    app.events.trigger 'users-connected',   usersConnected

  newUserConnected: (userInfo) =>
    app.events.trigger 'new-user-connected', userInfo

  userDisconnected: (userInfo) =>
    app.events.trigger 'user-disconnected', userInfo

  message: (message) =>
    app.events.trigger 'receieve-message', message



new SocketModule()