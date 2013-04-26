class CustomizableSVG.Elements.Line extends CustomizableSVG.Elements.Base
  
  # constructor: (el) ->
  #   
  #   @v1 = CustomizableSVG.Vertex.add @$el.attr('x1'), @$el.attr('y1')
  #   @v2 = CustomizableSVG.Vertex.add @$el.attr('x2'), @$el.attr('y2')
  #   @v1.on 'change', @handleChange
  #   @v2.on 'change', @handleChange
  #   @buildEdge()
    
  # buildEdge: =>
 #    if @$el.attr('customizable:length')
 #      @edge = CustomizableSVG.Edge.add @v1, @v2, @$el.attr('customizable:length')
 
  parseVertices:  =>
    @vertices = [
      new CustomizableSVG.Vertex(@$el.attr("x1"), @$el.attr("y1")),
      new CustomizableSVG.Vertex(@$el.attr("x2"), @$el.attr("y2"))
    ]
    
  render: =>
    @$el.attr
      x1: @vertices[0].get 'x'
      y1: @vertices[0].get 'y'
      x2: @vertices[1].get 'x'
      y2: @vertices[1].get 'y'
