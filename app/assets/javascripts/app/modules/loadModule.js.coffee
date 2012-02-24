LoadView = Backbone.View.extend
  className: 'modal'

  events:
    "click #done":"done"
    "keypress input": "doneWithEnter"

  done: (evt) ->
    enteredName = @$el.find('input').val() 
    enteredName = "Anonymous" if enteredName is ''
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