class mxFlowingTreeLayout extends mxGraphLayout
  constructor: (graph) ->
    super graph
    @model = @graph.model

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
    g.x = 0 + 100 * x
    g.y = 0 + 100 * y
    @model.setGeometry node, g

  execute: ->
    roots = @getAllVertices().filter (v) => @model.getIncomingEdges(v).length is 0
    stack = []
    for root in roots
      window.r = root
      @dfs root, (node, depth) ->
        stack.push node: node, depth: depth

    i = 0
    for el in stack
      console.log el.node, el.depth
      @moveNode el.node, el.depth, i
      i += 1

    @graph.refresh()
