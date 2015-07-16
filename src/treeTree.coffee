class Tree
  constructor: (@data, parent, @depth = 0) ->
    if parent instanceof Tree
      @parent = parent
      @parentEl = parent.childrenEl
    else
      @parent = null
      @parentEl = parent

    @el = @parentEl.group()
    @headerEl = @el.group()
    width = 500 - @depth * 30
    r = @headerEl.rect width, 0
    f = @headerEl.foreignObject width, 0
    contentWrapper = $('<div>').data('tree', @).addClass('node-wrapper').html(@data.content)[0]
    f.appendChild contentWrapper
    height = $(contentWrapper).outerHeight()
    r.height height
    f.height height

    if @data.children
      @childrenEl = @el.group().move(30, height + 10)
      for child in @data.children
        new Tree(child, @, @depth + 1)
      @recalcSize()

  recalcSize: ->
      h = 0
      for c in @childrenEl.children()
        c.move 0, h
        h += c.node.getBoundingClientRect().height + 10
