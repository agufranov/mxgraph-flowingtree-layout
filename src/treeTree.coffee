class Tree
  constructor: (@parentEl, @data, @depth = 0, @options = {}) ->
    console.log @data
    @options = $.extend { shiftWidth: 30, vMargin: 10, 'min-height': 0, padding: 10 }, @options

  render: ->
    @el = @parentEl.group()
    @headerEl = @el.group()
    r = @headerEl.rect()
    f = @headerEl.foreignObject()
    wrapper = $('<div>').css(padding: @options.padding, width: 500 - @depth * @options.shiftWidth, 'min-height': @options['min-height'], overflow: 'hidden', float: 'left').html(@data.content)[0]
    f.appendChild wrapper
    wrapperSize = [wrapper.scrollWidth, wrapper.scrollHeight]
    f.size wrapperSize...
    r.size wrapperSize...
    console.log wrapperSize

    @height = wrapperSize[1]

    if @data.children
      childrenHeightTotal = 0
      @childrenEl = @el.group().move @options.shiftWidth, wrapperSize[1] + @options.vMargin
      for child in @data.children
        childTree = new Tree(@childrenEl, child, @options)
        childTree.render()
        childTree.el.move 0, childrenHeightTotal
        childrenHeightTotal += childTree.height + @options.vMargin
      @height += childrenHeightTotal
