class Graph
  constructor: (@container, @vm) ->
    @graph = new mxGraph @container
    @parent = @graph.model.getParent()

    @graph.setEnabled false
    @graph.htmlLabels = true

    initPorts @graph

    window.g = @graph
    window.gm = @

    @draw()
    @addListener()

  draw: ->
    @withUpdate =>
      @createVertices()
      @arrangeVertices()
      @createEdges()

  withUpdate: (fn) ->
    @graph.model.beginUpdate()
    fn()
    @graph.model.endUpdate()
    @graph.refresh()


  addListener: ->
    @graph.addListener mxEvent.CLICK, (graph, event) =>
      cell = event.properties.cell
      return unless cell?.isVertex()
      cell.metadata.collapsed = !cell.metadata.collapsed
      @withUpdate =>
        @arrangeVertices()

  generateCounterFn: ->
    ( ->
      i = 0
      -> i++
    )()

  createVertices: (nodeVM, initial = true) ->
    nodeVM = @vm if initial
    vertex = @graph.insertVertex @parent, null, nodeVM.content, 0, 0, 200, 50
    @treeRoot = vertex if initial
    vertex.metadata = { treeChildren: [], collapsed: false }
    if nodeVM.children
      vertex.metadata.treeChildren.push(@createVertices(childNodeVM, false)) for childNodeVM in nodeVM.children
    vertex

  arrangeVertices: (counterFn = null, node = @treeRoot, depth = 0, visible = true) ->
    counterFn ||= @generateCounterFn()
    if visible
      treeFlatIndex = counterFn()
      @moveNode node, treeFlatIndex, depth
    node.setVisible visible
    for childNode in node.metadata.treeChildren
      @arrangeVertices counterFn, childNode, depth + 1, visible && !node.metadata.collapsed

  createEdges: (node = @treeRoot) ->
    for childNode in node.metadata.treeChildren
      @graph.insertEdge @parent, null, '', node, childNode, 'sourcePort=fromParent;targetPort=w;edgeStyle=orthogonalEdgeStyle;endArrow=none'
      @createEdges childNode

  moveNode: (node, i, j) ->
    geometry = node.getGeometry().clone()
    geometry.x = 0 + j * 50
    geometry.y = 0 + i * 70
    geometry.width = 300 - geometry.x
    console.log geometry
    node.setGeometry geometry
