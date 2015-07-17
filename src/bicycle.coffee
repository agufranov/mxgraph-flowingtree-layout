class A
  constructor: (@options = {}) ->
    _.defaults @options, @getDefaultOptions()

  getDefaultOptions: -> {}
  renderTo: (@_parentEl) ->
  moveTo: -> throw new Error 'Not Implemented'
  getHeight: -> throw new Error 'Not Implemented'
  _elFn: -> throw new Error 'Not Implemented'


class SvgA extends A
  constructor: (options) -> super options
  moveTo: (x, y) ->
    @_el.move x, y
    @
  moveBy: (x, y) ->
    @_el.dmove x, y
    @
  getHeight: -> @_el.node.getBBox().height
  renderTo: (_parentEl) ->
    super _parentEl
    @_el = @_elFn @_parentEl
    @
  _elFn: (parentEl) -> parentEl.group()


class R extends SvgA
  constructor: (@width, @height) -> super()
  renderTo: (@_parentEl) -> @_el = @_parentEl.rect(@width, @height).stroke('#FEE')
  _elFn: (parentEl) -> parentEl.rect @width, @height


class HR extends SvgA
  constructor: (@content, options) ->
    super options

  getDefaultOptions: -> _.merge super(), htmlPadding: 10, htmlWidth: null

  renderTo: (_parentEl) ->
    super _parentEl
    r = @_el.rect()
    f = @_el.foreignObject()
    wrapper = $('<div>').css(padding: @options.htmlPadding, float: 'left', width: @options.htmlWidth).html @content
    f.appendChild wrapper[0]
    wrapperSize = [ wrapper.outerWidth(), wrapper.outerHeight() ]
    r.size wrapperSize...
    f.size wrapperSize...
    

class G extends SvgA
  constructor: (options) ->
    super options
    @_children = []

  getDefaultOptions: -> _.merge super(), groupChildMargin: 5

  renderTo: (_parentEl) ->
    super _parentEl
    for child in @_children
      child.renderTo @_el
    @arrangeChildren()

  getHeight: -> @height

  addChild: (child) ->
    @_children.push child
    child

  arrangeChildren: ->
    heightAcc = 0
    return unless @_children.length
    for child, index in @_children
      child.moveTo 0, heightAcc
      heightAcc += child.getHeight()
      heightAcc += @options.groupChildMargin if index < @_children.length - 1
      debugger if _.isNaN heightAcc
    @height = heightAcc


class T extends G
  constructor: (@data, @depth = 0, options) ->
    super options
    @options.groupChildMargin = @options.treeNestedMargin
    @_headerEl = @addChild new HR @data.c, htmlWidth: @options.treeWidth - @options.treeDepthShift * @depth
    if @data.d
      @_childrenEl = @addChild new G groupChildMargin: @options.treeFlatMargin
      @_childrenEl.addChild new T childData, @depth + 1, options for childData in @data.d

  getDefaultOptions: -> _.merge super(), treeFlatMargin: 20, treeNestedMargin: 5, treeDepthShift: 30, treeWidth: 300

  renderTo: (_parentEl) ->
    super _parentEl
    # TODO public method
    @_childrenEl.moveBy @options.treeDepthShift, 0 if @_childrenEl
