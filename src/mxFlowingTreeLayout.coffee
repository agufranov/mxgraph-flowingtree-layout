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

  moveNode: (node, x, y) ->
    g = @model.getGeometry node
    g.x = 0 + @options.dx * x
    g.y = 0 + @options.dy * y
    @model.setGeometry node, g

  execute: ->
    roots = @getAllVertices().filter (v) => @model.getIncomingEdges(v).length is 0
    i = 0

    for root in roots
      window.r = root
      @dfs root, (node, depth) =>
        @moveNode node, depth, i
        i++

    @graph.refresh()
