$ ->
  data = {
    id: 0
    content: '<div><span>i</span><a href="#">Link</a><div>e</div></div>'
    children: [
      {
        id: 1, content: '1', children: [
          {
            id: 12
            content: '12'
            children: [
              { id: 121, content: '<div>121</div><div><a href="#">here</a></div><div><span>pp</span></div>' }
              { id: 122, content: '122' }
            ]
          }
        ]
      }
      {
        id: 2, content: '2', children: [
          { id: 22, content: '22' }
        ]
      }
    ]
  }

  new Tree data, SVG(document.getElementById('svg'))
