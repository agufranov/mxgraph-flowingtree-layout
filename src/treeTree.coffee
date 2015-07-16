class TreeBase
  constructor: (@data, parent, @depth = 0, @options = {}) ->
    # Default options
    @options = $.extend { vShift: 90, hMargin: 20, parentLineShift: 30 }, @options
    # Setup parent
    [@parent, @parentEl] = if parent instanceof Tree then [parent, parent.childrenEl] else [null, parent]
  createElements: ->
    # Main wrapper
    @el = @parentEl.group()
    # Header wrapper
    @headerEl = @el.group()
    # Children wrapper
    if @data.children
      @childrenEl = @el.group()

  render: ->

class Tree
  constructor: (@data, parent, @depth = 0, @options = {}) ->
    @options = $.extend { vShift: 90, hMargin: 20, parentLineShift: 30 }, @options
    [@parent, @parentEl] = if parent instanceof Tree then [parent, parent.childrenEl] else [null, parent]

    @el = @parentEl.group()

    @headerEl = @el.group()
    width = 500 - @depth * @options.vShift
    r = @headerEl.rect width, 0
    f = @headerEl.foreignObject width, 0
    contentWrapper = $('<div>').data('tree', @).addClass('node-wrapper').html(@data.content)[0]

    $(contentWrapper).on 'click', (event) =>
      tree = $(event.currentTarget).data('tree')
      tree.toggle()

    f.appendChild contentWrapper
    height = $(contentWrapper).outerHeight()
    r.height height
    f.height height

    if @depth > 0
      @childLine = @headerEl.line(0, height / 2, - (@options.vShift - @options.parentLineShift), height / 2).addClass('tree-line')

    if @data.children
      @childrenEl = @el.group().move(@options.vShift, height + @options.hMargin)
      @childTrees = (new Tree(child, @, @depth + 1) for child in @data.children)
      @recalcSize()

  updateParentLine: ->
      h = @.getParentLineHeight()
      x = - (@options.vShift - @options.parentLineShift)
      if not @parentLine
        @parentLine = @.childrenEl.line(x, - @options.hMargin, x, h).addClass('tree-line')
      else
        @parentLine.plot(x, - @options.hMargin, x, h)

  getParentLineHeight: ->
    h = 0
    for childTree, i in @childTrees
      if not (last = i is @childTrees.length - 1)
        h += @h(childTree.el) + @options.hMargin
      else
        h += @h(childTree.headerEl) / 2
    h

  recalcSize: (recursive = false) ->
    childrenHeightTotal = 0
    for childGroup in @childrenEl.children()
      if childGroup.node.tagName is 'g'
        childGroup.move 0, childrenHeightTotal
        childrenHeightTotal += @h(childGroup) + @options.hMargin
    if recursive and @parent
      @parent.recalcSize recursive
    @updateParentLine()

  hasChildren: -> @data.children?.length > 0

  h: (svg) -> svg.node.getBoundingClientRect().height

  toggle: ->
    if @hasChildren()
      $(@childrenEl.node).toggle()
      @recalcSize true
