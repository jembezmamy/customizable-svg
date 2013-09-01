class CustomizableSVG.Elements.Line extends CustomizableSVG.Elements.Base
 
  parseVertices:  =>
    [
      new CustomizableSVG.Vertex(@$el.attr("x1"), @$el.attr("y1")),
      new CustomizableSVG.Vertex(@$el.attr("x2"), @$el.attr("y2"))
    ]
    
  render: =>
    @$el.attr
      x1: @getPosition 0, "x"
      y1: @getPosition 0, "y"
      x2: @getPosition 1, "x"
      y2: @getPosition 1, "y"
