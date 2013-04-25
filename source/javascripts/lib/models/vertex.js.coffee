class CustomizableSVG.Vertex extends CustomizableSVG.Model
  @all: null
  
  @add: (x, y) ->
    @all ||= []
    @find(x, y) || @all[@all.length] = new CustomizableSVG.Vertex(x, y)
    
  @find: (x, y) ->
    x = Number(x)
    y = Number(y)
    for vertex in @all
      return vertex if vertex.get('x') == x && vertex.get('y') == y
    null
  
  constructor: (x, y) ->
    @attr = x: Number(x), y: Number(y), version: 0