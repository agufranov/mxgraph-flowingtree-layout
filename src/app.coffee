$ ->
  data =
    # { content: 'a', children: [
    #   { content: 'b' }
    #   { content: 'c' }
    # ]}
  {
    c: '<span>ALPHABETAGAMMA</span>'
    d: [
      {
        c: '1', d: [
          {
            c: '12'
            d: [
              { c: '<div>121</div><div><a href="#">here</a></div><div><span>pp</span></div>' }
              { c: '122', d: [
                { c: '1221' }
                { c: '1222' }
                { c: '1223' }
              ]}
              { c: '123', d: [ { c: '1231' }, { c: '1232' } ] }
            ]
          }
        ]
      }
      {
        c: '2', d: [
          { c: '22' }
        ]
      }
    ]
  }

  window.s = SVG(document.getElementById('svg'))
  # window.g = new G
  # g.addChild new R 200, 50
  # g.addChild new R 160, 70
  # g.addChild new HR '<h3>Hi</h3>'
  # g.addChild new R 160, 70
  # g.renderTo s
  window.t = new T data
  t.renderTo s
