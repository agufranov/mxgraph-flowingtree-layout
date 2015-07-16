$ ->
  data = {
    content: '<div><span>i</span><a href="#">Link</a><div>e</div></div>'
    children: [
      {
        content: '1', children: [
          {
            content: '12'
            children: [
              { content: '<div>121</div><div><a href="#">here</a></div><div><span>pp</span></div>' }
              { content: '122', children: [
                { content: '1221' }
                { content: '1222' }
                { content: '1223' }
              ]}
              { content: '123', children: [ { content: '1231' }, { content: '1232' } ] }
            ]
          }
        ]
      }
      {
        content: '2', children: [
          { content: '22' }
        ]
      }
    ]
  }

  # window.t = new Tree data, SVG(document.getElementById('svg'))
  window.s = SVG(svg)
  window.h1 = new HtmlTreeStack s, '<h1>Hello</h1><div><a href="#">[link]</a></div><div>a</div><div>a</div>', 30, null
  window.h2 = new HtmlTreeStack s, '<h1>Hello</h1><div><a href="#">[link]</a></div><div>a</div><div>a</div>', 30, null
  window.g = new GroupTreeStack s
  g.children.push h1, h2
  g.render()
