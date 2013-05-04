class CustomizableSVG.Elements.Line extends CustomizableSVG.Elements.Base
 
  parseVertices:  =>
    [
      new CustomizableSVG.Vertex(@$el.attr("x1"), @$el.attr("y1")),
      new CustomizableSVG.Vertex(@$el.attr("x2"), @$el.attr("y2"))
    ]
    
  render: =>
    @$el.attr
      x1: @vertices[0].get 'x'
      y1: @vertices[0].get 'y'
      x2: @vertices[1].get 'x'
      y2: @vertices[1].get 'y'
