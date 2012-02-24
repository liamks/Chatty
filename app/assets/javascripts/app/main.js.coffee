class BackboneApp
  constructor: () ->
    @events = _.extend({}, Backbone.Events)
    @fetchUserInfo()

  start: ->
    Backbone.history.start
      root: '/chatty'
    @events.trigger 'start', ''

  template: (name, context) ->
    JST["app/templates/#{name}"] context

  processInfo: (info) =>
    @socketURL = info.socketURL
    @events.trigger 'connect-info', info

  fetchUserInfo: () =>
    $.ajax
      url : '/get_user_info.json'
      success: @processInfo

@app = new BackboneApp()






