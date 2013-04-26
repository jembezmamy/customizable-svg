class CustomizableSVG.Elements.Base
  $el: null
  edges: null
  vertices: null
  
  constructor: (el) ->
    @$el = $(el)
    @parseVertices()
    @buildDynamicVertices()
    @buildEdges()
      
  buildDynamicVertices: =>
    return unless @$el.attr('customizable:points')
    pointDefinitions = @$el.attr('customizable:points').split /\s*;\s*/
    for definition in pointDefinitions
      [from, to] = 
        if definition == 'all'
          [0, @vertices.length-1]
        else if match = definition.match /([0-9]+)\s*-\s*([0-9]+)/
          [Number(match[1]), Number(match[2])]
        else if definition.match /[0-9]+/
          [Number(definition), Number(definition)]
        else [0, -1]
      if from <= to
        @makeVertexDynamic i for i in [from..to]
    
  buildEdges: =>
    @edges = []
    return unless @$el.attr('customizable:lengths')
    lastVertexIndex = 0
    edgeDefinitions = @$el.attr('customizable:lengths').split ';'
    for definition in edgeDefinitions
      vertices = definition.match /^([0-9]+)\s*,\s*([0-9]+)/
      if vertices
        index1 = Number(vertices[1])
        index2 = Number(vertices[2])
      else
        index1 = lastVertexIndex
        index2 = lastVertexIndex+1
      vertex1 = @makeVertexDynamic index1
      vertex2 = @makeVertexDynamic index2
      lastVertexIndex = index2
      length = definition.replace /^([0-9]+)\s*,\s*([0-9]+):/, ""
      @edges.push CustomizableSVG.Edge.add vertex1, vertex2, length
      
  makeVertexDynamic: (i) =>
    unless @vertices[i].inCollection
      @vertices[i] = CustomizableSVG.Vertex.add @vertices[i].get('x'), @vertices[i].get('y')
      @vertices[i].on "change", @handleChange
    @vertices[i]
    
  handleChange: =>
    @render()
    
  # abstract methods
  
  parseVertices: =>
    @vertices = []
    @warnAboutAbstractMethod("parseVertices")
    
  render: =>
    @warnAboutAbstractMethod("render")
      
  warnAboutAbstractMethod: (methodName) =>
    console.warn "#{methodName} is an abstract method. You should extend it in your subclass (#{@constructor.name})."
    