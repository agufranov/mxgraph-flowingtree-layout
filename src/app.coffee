$ ->
  window.g = new mxGraph(document.getElementById('container'))

  g.setEnabled(false)
  g.setConnectable(true)
  parent = g.getDefaultParent()
  # new mxRubberband(g)
  # prts(g)

  iv = (n, p = parent) ->
    window["v#{n}"] = g.insertVertex p, null, n, 0, 0, 100, 30

  ie = (n1, n2) ->
    window["e#{n1}_#{n2}"] = g.insertEdge parent, null, "#{n1}_#{n2}", window["v#{n1}"], window["v#{n2}"]

  iv 1
  iv 11
  iv 12
  iv 111
  iv 112
  iv 121
  iv 2
  iv 22

  ie 1, 11
  ie 1, 12
  ie 11, 111
  ie 11, 112
  ie 12, 121
  ie 2, 22

  layout = new mxXLayout(g)

  layout.execute()
