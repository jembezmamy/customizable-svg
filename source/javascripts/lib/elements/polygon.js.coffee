class CustomizableSVG.Elements.Polygon extends CustomizableSVG.Elements.Base
  @closedShape: true
  
  parseVertices: =>
    vertices = []
    data = @$el.attr('points')
    pattern = /([0-9]+(\.[0-9]+|))\s*,\s*([0-9]+(\.[0-9]+|))/g
    while matches = pattern.exec data
      vertices.push new CustomizableSVG.Vertex matches[1], matches[3]
    vertices
    
  render: =>
    data = []
    for v, i in @vertices
      data.push "#{@getPosition i, 'x'},#{@getPosition i, 'y'}"
    @$el.attr points: data.join ' '