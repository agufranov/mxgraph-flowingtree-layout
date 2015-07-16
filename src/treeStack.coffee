class Tree
  constructor: (@group, @data, @options = {}) ->
    @options = $.extend { shiftWidth: 50, verticalMargin: 10, parentLineOffset: 5 }, @options
    @height = 0
    @fill @data

  fill: (node, depth = 0) ->
    @push node.content, depth
    return unless node.children
    for child in node.children
      @fill child, depth + 1

  getPosition: (depth) ->
    [ depth * @options.shiftWidth, @height ]

  push: (content, depth) ->
    position = @getPosition(depth)

    # construct containers and svg elements
    group = @group.group().move position...
    rectSizeInitial = [500 - position[0], 0]
    console.log rectSizeInitial
    rect = group.rect rectSizeInitial...
    foreignObject = group.foreignObject rectSizeInitial...

    # create content wrapper
    contentWrapper = $('<div>').addClass('node-wrapper').css('min-height': '30px').html(content)[0]
    # render wrapper to DOM
    foreignObject.appendChild contentWrapper
    # get size of wrapper
    contentHeight = $(contentWrapper).outerHeight()

    # resize SVG containers to fit content
    rect.height contentHeight
    foreignObject.height contentHeight

    # add tree child line (if not root)
    if depth > 0
      lineWidth = @options.shiftWidth - @options.parentLineOffset
      group.line(0, 0, lineWidth, 0).move(- lineWidth, contentHeight / 2).stroke('green')

    @recalcSize contentHeight

  recalcSize: (nodeHeight) ->
    @height += nodeHeight + @options.verticalMargin

class Graph
  constructor: (@data, @el, @options = {}) ->
    @options.childShiftWidth ||= 50
    @svg = SVG @el
    window.s = @svg
    @treeGroup = @svg.group()
    @treeCount = 0
    @treeHeight = 0

    @tree = new Tree(@treeGroup, @data)
