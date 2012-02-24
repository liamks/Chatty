# Backbone On Rails
## A Backbone.js Rails Integration Template

Much of the code organization in Backbone on Rails is based on Tim Branyen's Backbone Boilerplate. Backbone Boilerplate provides an excellent example of how to organize code within a Backbone project and it provides build dools to concatenate and minify JavaScript files. Furthermore it provides a module system for organizing code and a wrapper for JavaScript templates. 

I created this project because I wanted to leverage the asset pipeline and use haml and coffeescript. The asset pipeline can concatenate and minify JavaScript files, while the `ejs` gem allows one to use JavaScripte templates. Furthermore Rails 3 makes it easy to use CoffeesScript. 

I loosely organized the code into modules, similar to the Backbone Biolerplate. the most significant difference is all the communication between modules occurs using events. This eliminates the need to pass variables into modules and makes it extremely easy to add new modules. For instance, here is the `index` route:

```coffeescript
Router = Backbone.Router.extend
  routes:
    "":"index"

  index: () ->
    app.events.trigger('route.index',this);
```

Instead of instantiated a new view and rendering it, the router merely broadcast the event and it's up to the module to handle the `route.index` event. This is the Example module:

```coffeescript
ExampleView = Backbone.View.extend
  render: () ->
    temp = app.template 'sample', {name:'world'}
    $("#main").append(temp);

class ExampleModule
  constructor: ->
    @eventHandlers()
    @exampleView = new ExampleView()

  eventHandlers: ->
    app.events.on 'start',() =>
      @exampleView.render()

    app.events.on 'route.index', () =>
      @exampleView.render()

new ExampleModule()
```

The example module is rendered either when the app starts or when the use navigates back to the index action.

The entire Backbone application is stored within `app/assets/javascripts/app`. The asset pipeline uses `app/assets/javascripts/backboneApp.js` to load all the Backbone app files and the templates. Library JavaScript files are stored in `lib/assets/javascripts`. For good measure I also included Bootstrap!

