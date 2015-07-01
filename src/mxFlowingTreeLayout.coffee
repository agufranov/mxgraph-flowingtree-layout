class mxFlowingTreeLayout extends mxGraphLayout
  constructor: (graph, @options = {}) ->
    super graph
    @model = @graph.model
    @options.dx ||= 40
    @options.dy ||= 50

    # debug
    window.g = graph
    window.m = @model

  getAllVertices: ->
    @model.root.children[0].children.filter (v) -> v.isVertex()

  getTreeChildren: (node) ->
    edges = @model.getOutgoingEdges node
    edges.map (edge) -> edge.target

  dfs: (node, fn, depth = 0) ->
    fn node, depth
    for treeChild in @getTreeChildren node
      @dfs treeChild, fn, depth + 1

  dfs2: (node, depth = 0, visible = true) ->
    @moveNode node, depth, i
    i += 1 if visible
    node.setVisible visible
    for treeChild in @getTreeChildren node
      if node.data?.collapsed
        visible = false
      @dfs2 treeChild, depth + 1, visible

  dfs3: (node, counter, depth = 0) ->
    @moveNode node, depth, counter.call()
    # console.log depth
    for treeChild in node.treeChildren
      # console.log 'treeChild', treeChild
      @dfs3 treeChild, counter, depth + 1

  moveNode: (node, x, y) ->
    g = @model.getGeometry node
    g.x = 0 + @options.dx * x
    g.y = 0 + @options.dy * y
    @model.setGeometry node, g

  execute: ->
    @graph.getModel().beginUpdate()
    try
      roots = @getAllVertices().filter (v) => @model.getIncomingEdges(v).length is 0

      for root in roots
        window.r = root
        # @dfs2 root

        i = [0]
        
        @dfs3 root, ->
          console.log 'COUNTER', i
          i[0]++

        
        # @dfs root, (node, depth) =>
        #   @moveNode node, depth, i
        #   i++

    finally
      # morph = new mxMorphing(@graph, 15, 1.2, 50)
      # morph.startAnimation()
      # morph.addListener mxEvent.DONE, =>
      #   @graph.getModel().endUpdate()
      #   @graph.refresh()
      @graph.getModel().endUpdate()
      @graph.refresh()
