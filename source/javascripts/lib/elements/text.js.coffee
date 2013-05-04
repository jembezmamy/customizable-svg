class CustomizableSVG.Elements.Text extends CustomizableSVG.Elements.Base
  
  parseVertices:  =>
    [
      new CustomizableSVG.Vertex(@$el.attr("x"), @$el.attr("y"))
    ]
    
  render: =>
    @$el.attr
      x: @vertices[0].get 'x'
      y: @vertices[0].get 'y'