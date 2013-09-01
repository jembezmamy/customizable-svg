class CustomizableSVG.Elements.Text extends CustomizableSVG.Elements.Base
  
  parseVertices:  =>
    [
      new CustomizableSVG.Vertex(@$el.attr("x"), @$el.attr("y"))
    ]
    
  render: =>
    @$el.attr
      x: @getPosition 0, 'x'
      y: @getPosition 0, 'y'