Message = Backbone.Model.extend
  toJSON: () ->
      screenName: @.get('screenName')
      message: @.get('message')

Messages = Backbone.Collection.extend
  model: Message

MessageView = Backbone.View.extend
  className: 'message-wrapper'

  initialize: () ->
    @model.view = @

  render: () ->
    @$el.html app.template 'message', @model.toJSON()
    if @model.get('isFromMe')
      @$el.addClass 'is-from-me'
    @$el

  show: () ->
    @$el.show()

  hide: () ->
    @$el.hide()

MessagesView = Backbone.View.extend
  el: '#messages-inner'

  initialize: () ->
    @collection = new Messages()
    @collection.on 'add', @addMessage, @
    @eventHandlers()

  eventHandlers: () ->
    app.events.on 'send-message', (messagePacket) =>
      @collection.add messagePacket

    app.events.on 'receieve-message', (messagePacket) =>
      @collection.add messagePacket

    app.events.on 'change-url', (user) =>
      @filter user

  addMessage: (message) ->
    messageView = new MessageView
      model: message
    @$el.append messageView.render()
    @$el.animate
      scrollTop: 490

  filter: (user) ->
    if user is ''
      @collection.each (message) ->
        message.view.show()
    else
      @collection.each (message) ->
        if message.get('userId') isnt user.id
          message.view.hide()
        else
          message.view.show()

SendMessageView = Backbone.View.extend
  el: '#input'

  initialize: () ->
    @$input = @$el.find('input')

    app.events.on 'screenName-entered', () =>
      @$input.focusin()

    app.events.on 'user', (user) =>
      @user = user

  events:
    'click button': 'sendMessage'
    "keypress input": "sendMessageWithEnter"

  sendMessage: (evt) ->
    message = @$input.val()
    @$input.val('')

    app.events.trigger 'send-message'
      userId: @user.id
      screenName: @user.get 'screenName'
      time: (new Date()).getTime()
      message: message
      isFromMe: yes

    evt.preventDefault()

  sendMessageWithEnter: (evt) ->
    if evt.keyCode is 13
      @sendMessage evt


class MessageModule
  constructor: () ->
    @messagesView = new MessagesView()
    @sendMessageView = new SendMessageView()



messageModule = new MessageModule()

