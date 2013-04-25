class CustomizableSVG.Line
  @$el: null
  
  constructor: (el) ->
    @$el = $(el)
    @v1 = CustomizableSVG.Vertex.add @$el.attr('x1'), @$el.attr('y1')
    @v2 = CustomizableSVG.Vertex.add @$el.attr('x2'), @$el.attr('y2')
    @edge = CustomizableSVG.Edge.add @v1, @v2, @$el.attr('customizable:length')
    @v1.on 'change', @handleChange
    @v2.on 'change', @handleChange
    
  render: =>
    @$el.attr
      x1: @v1.get 'x'
      y1: @v1.get 'y'
      x2: @v2.get 'x'
      y2: @v2.get 'y'
    
  handleChange: =>
    @render()