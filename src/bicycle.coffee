# Model with onHeightChanged event
class HeightPublisher
  constructor: ->
    @__heightChangedCallbacks = []

  getHeight: -> throw new Error 'Not Implemented'

  onHeightChanged: (cb) -> @__heightChangedCallbacks.push cb
  notifyHeightChanged: -> cb @, @getHeight() for cb in @__heightChangedCallbacks


# SVG group as node of tree stack
class TreeStack extends HeightPublisher
  constructor: (@_parentEl) ->
    super arguments...
    @domInitialized = false

  getHeight: ->
    @_el.node.getBoundingClientRect().height

  # This method affects DOM, renders and fires 'height changed' event
  render: ->
    @_initDOM() unless @domInitialized
    @_renderFn()
    @notifyHeightChanged()

  # Abstract. Must be overriden
  _renderFn: -> throw new Error 'Not Implemented'

  _gClass: -> throw new Error 'Not Implemented'

  _initDOM: ->
    @_el = @_parentEl.group().addClass(@_gClass())
    console.log 'DOM Initialized'
    @domInitialized = true


# Renders HTML content inside SVG and fits height
class HtmlTreeStack extends TreeStack
  constructor: (@_parentEl, @content, @minHeight, @defaultWidth = '100%') ->
    super arguments...

  _renderFn: ->
    @_el.clear()
    [rect, foreignObject] = [@_el.rect(@width, 0), @_el.foreignObject @width, 0]
    wrapper = $('<div>').css(width: @defaultWidth, 'min-height': @minHeight).addClass('content-wrapper').html(@content)[0]
    foreignObject.appendChild wrapper
    [width, height] = [$(wrapper).outerWidth(), $(wrapper).outerHeight()]
    console.log width, height
    rect.size width, height
    foreignObject.size width, height

  _gClass: -> 'html-tree-stack'


# SVG group with nesting
class GroupTreeStack extends TreeStack
  constructor: (@_parentEl, @children = []) ->
    super arguments...

  _renderFn: ->
    for child in @children
      child._parentEl = @_el
      child.onHeightChanged -> console.log 'Changed!', arguments
      child.render()

  _gClass: -> 'group-tree-stack'
