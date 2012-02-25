# User Model
User = Backbone.Model.extend
  defaults:
    screenName: 'You'
    isMe: no

  toJSON: () ->
    cid: @cid
    screenName: @get('screenName')
    isMe: @get('isMe')

# User Collection
Users = Backbone.Collection.extend
  model: User

# User View (Display a single li element)
UserView = Backbone.View.extend
  tagName: 'li'

  initialize: () ->
    @model.on 'change:screenName', @setName, this
    @model.view = this

  setName: () ->  
    @$el.html app.template 'user', @model.toJSON()

  render: () ->
    @setName()
    @$el

  clickedUser: (evt) ->
    @$el.addClass('active')

  remove: () ->
    @$el.addClass 'remove-red'
    @$el.fadeOut 3000, () =>
      Backbone.View.prototype.remove.call @

# Users View 
UsersView = Backbone.View.extend
  initialize:  () ->
    @collection.on 'add',     @addUser,     @
    @collection.on 'remove',  @removeUser,  @
    @$numUsers = $("#num-users")

  addUser: (user) ->
    @$numUsers.text @collection.length
    view = new UserView
      model: user
    @$el.append view.render()
    @$numUsers

  removeUser: (user) ->
    @$numUsers.text @collection.length
    user.view.remove()

# User Router
UserRouter = Backbone.Router.extend
  routes:
    ""           : "allUsers"
    "users"      : "allUsers"
    "users/:cid" : "usersMessages"

  initialize: (options) ->
    @users = options.users
    @$userList = $("#user-list")
    @$allMessages = $(@$userList.children()[1])

  allUsers:() ->
    @removeActive()
    @$allMessages.addClass('active')
    app.events.trigger 'change-url', ''

  usersMessages: (cid) ->
    @removeActive()
    @users.getByCid(cid).view.clickedUser()
    app.events.trigger 'change-url', @users.getByCid(cid)

  removeActive:() ->
    @$userList.children().removeClass('active')
    
# User Module
class UserModule
  constructor: () ->
    @user = new User
      isMe: yes

    @users = new Users()
    @usersView = new UsersView
      collection: @users
      el: "#user-list"

    @router = new UserRouter
      users: @users

    @users.add @user
    @addHandlers()

  addHandlers: () ->
    app.events.on 'connect-info', (info) =>
      @user.id = info.id
      @publishUser()

    app.events.on 'screenName-entered', (screenName) =>
      @user.set 'screenName', screenName
      @publishUser()

    app.events.on 'new-user-connected', (userInfo) =>
      @users.add(userInfo)

    app.events.on 'users-connected', (usersConnected) =>
      @users.add(usersConnected)

    app.events.on 'user-disconnected', (userInfo) =>
      model = @users.get userInfo.id
      @users.remove(model)


  publishUser: () ->
    if @user.id isnt undefined and @user.get('screenName') isnt 'You'
      app.events.trigger 'user', @user

userModule = new UserModule()

