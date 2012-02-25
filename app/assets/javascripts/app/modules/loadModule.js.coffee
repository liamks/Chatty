LoadView = Backbone.View.extend
  className: 'modal'

  events:
    "keypress input": "doneWithEnter"
    "click #done":"done"

  initialize: () ->
    @closedWindow = no

    @$el.on 'hidden', (evt) =>
      @done evt

  done: (evt) ->
    
    if not @closedWindow
      @closedWindow = yes
      enteredName = @$el.find('input').val() 
      anonName = 'Anonymous' + String((new Date()).getTime() % 1000)
      enteredName = anonName if enteredName is ''
      app.events.trigger 'screenName-entered', enteredName
      @$el.modal 'hide'
      evt.preventDefault()

  doneWithEnter: (evt) ->
    if evt.keyCode is 13
      @done evt

  render: () ->
    temp = app.template 'modal', {}
    @$el.html(temp)
    @$el.modal
      backdrop: true

    @$el.find('input').focus()

class LoadModule
  constructor: ->
    @eventHandlers()
    @loadView = new LoadView()

  eventHandlers: ->
    app.events.on 'start',() =>
      @loadView.render()

new LoadModule()