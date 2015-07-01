$ ->
  data = {
    content: '<div><span>i</span><a href="#">Link</a></div>'
    children: [
      {
        content: '1', children: [
          {
            content: '12'
            children: [
              { content: '121' }
              { content: '122' }
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

  new Graph document.getElementById('container'), data
