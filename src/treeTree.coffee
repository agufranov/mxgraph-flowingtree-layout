class Tree
  constructor: (@parentEl, @data, @depth = 0, @options = {}) ->
    console.log @data
    @options = $.extend { shiftWidth: 50, parentLineOffset: 10, vMargin: 10, treeWidth: 300, 'min-height': 0, padding: 10 }, @options

  render: ->
    @el = @parentEl.group()
    @headerEl = @el.group()
    r = @headerEl.rect()
    f = @headerEl.foreignObject()
    wrapper = $('<div>').css(padding: @options.padding, width: @options.treeWidth - @depth * @options.shiftWidth, 'min-height': @options['min-height'], overflow: 'hidden', float: 'left').html(@data.content)[0]
    f.appendChild wrapper
    wrapperSize = [wrapper.scrollWidth, wrapper.scrollHeight]
    f.size wrapperSize...
    r.size wrapperSize...
    console.log wrapperSize

    @height = wrapperSize[1]

    if @depth > 0
      @headerEl.line(0, @height / 2, - (@options.shiftWidth - @options.parentLineOffset), @height / 2).addClass('tree-line')

    if @data.children?.length > 0
      @height += @options.vMargin
      childrenHeightTotal = 0
      @childrenEl = @el.group().move @options.shiftWidth, wrapperSize[1] + @options.vMargin

      @childTrees = (new Tree(@childrenEl, child, @depth + 1, @options) for child in @data.children)

      for childTree, index in @childTrees
        childTree.render()
        childTree.el.dy childrenHeightTotal
        childrenHeightTotal += childTree.height + if index isnt @data.children.length - 1 then @options.vMargin else 0
      @height += childrenHeightTotal

      parentLineHeight = 0
      for childTree, index in @childTrees
        parentLineHeight += if index isnt @childTrees.length - 1 then childTree.height + @options.vMargin else childTree.headerEl.node.getBoundingClientRect().height / 2

      @childrenEl.line(0, - @options.vMargin, 0, parentLineHeight).dx( - (@options.shiftWidth - @options.parentLineOffset)).addClass('tree-line')
