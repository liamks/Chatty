class SocketModule
  constructor: () ->
    @addHandlers()
    #for what ever reason usersConnected is called twice
    # on firefox
    @usersConnectedFlag = no

  addHandlers: () ->
    app.events.on 'connect-info',       @connect
    app.events.on 'screenName-entered', @registerUser
    app.events.on 'send-message',       @sendMessage


  connect: (info) =>
    @url = info.socketURL
    @uuid = info.uuid
    @socket = io.connect @url
    @addSocketHandlers()

  registerUser: (screenName) =>
    @socket.emit 'new-user',
      screenName: screenName
      uuid:       @uuid

  sendMessage: (msgInfo) =>
    @socket.emit 'message', msgInfo

  addSocketHandlers: () ->
    @socket.on 'users-connected',     @usersConnected
    @socket.on 'new-user-connected',  @newUserConnected 
    @socket.on 'user-disconnected',   @userDisconnected
    @socket.on 'receieve-message',             @message

  usersConnected: (usersConnected) =>
    if not @usersConnectedFlag
      @usersConnected = yes
      app.events.trigger 'users-connected',   usersConnected

  newUserConnected: (userInfo) =>
    app.events.trigger 'new-user-connected', userInfo

  userDisconnected: (userInfo) =>
    app.events.trigger 'user-disconnected', userInfo

  message: (message) =>
    app.events.trigger 'receieve-message', message



new SocketModule()