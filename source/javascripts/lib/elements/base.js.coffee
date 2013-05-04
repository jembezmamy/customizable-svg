class CustomizableSVG.Elements.Base
  @all: []
  
  @findById: (id) =>
    for element in @all
      return element if element.id == id
      
  @buildBindings: =>
    element.buildBindings() for element in @all
  
  
  $el: null
  id: ""
  edges: null
  vertices: null
  @closedShape: false
  
  constructor: (el) ->
    CustomizableSVG.Elements.Base.all.push this
    @$el = $(el)
    @id = @$el.attr('id')
    @vertices = @parseVertices()
    @buildDynamicVertices()
    @buildRigidEdges()
    @buildElasticEdges()
      
  buildDynamicVertices: =>
    return unless @$el.attr('customizable:points')
    pointDefinitions = @$el.attr('customizable:points').split /\s+/
    for definition in pointDefinitions
      [from, to] = 
        if definition == 'all'
          [0, @vertices.length-1]
        else if match = definition.match /([0-9]+)-([0-9]+)/
          [Number(match[1]), Number(match[2])]
        else if definition.match /[0-9]+/
          [Number(definition), Number(definition)]
        else [0, -1]
      if from <= to
        @makeVertexDynamic i for i in [from..to]
    
  buildRigidEdges: =>
    @edges = []
    return unless @$el.attr('customizable:lengths')
    lastVertexIndex = 0
    edgeDefinitions = @$el.attr('customizable:lengths').split /\s+/
    for definition in edgeDefinitions
      vertices = definition.match /^([0-9]+),([0-9]+)/
      if vertices
        index1 = Number(vertices[1])
        index2 = Number(vertices[2])
      else
        index1 = lastVertexIndex
        index2 = lastVertexIndex+1
      vertex1 = @makeVertexDynamic index1
      vertex2 = @makeVertexDynamic index2
      lastVertexIndex = index2
      length = definition.replace /^([0-9]+),([0-9]+):/, ""
      @edges.push CustomizableSVG.Edge.add vertex1, vertex2, length: length
      
  buildElasticEdges: =>
    if @vertices.length > 1
      for i in [0..@vertices.length-2]
        CustomizableSVG.Edge.add @vertices[i], @vertices[i+1], elastic: true
      if @constructor.closedShape
        CustomizableSVG.Edge.add @vertices[@vertices.length-1], @vertices[0], elastic: true
  
  buildBindings: =>
    if @$el.attr('customizable:bindings')
      bindingsDefinitions = @$el.attr('customizable:bindings').split /\s+/
      for definition in bindingsDefinitions
        vertices = definition.match /^#*([^\/]*)\/*([0-9]+):#*([^\/]*)\/*([0-9]+)/
        v1 = @findVertex vertices[1], vertices[2]
        console.warn "##{vertices[1]}/#{vertices[2]} - vertex not found" unless v1
        v2 = @findVertex vertices[3], vertices[4]
        console.warn "##{vertices[3]}/#{vertices[4]} - vertex not found" unless v2
        if v1 && v2
          CustomizableSVG.Edge.add v1, v2, elastic: true
  
  findVertex: (elementId, vertexIndex) =>
    element = if elementId
      CustomizableSVG.Elements.Base.findById elementId
    else
      this
    element.vertices[Number(vertexIndex)] if element
      
  makeVertexDynamic: (i) =>
    unless @vertices[i].inCollection
      @vertices[i] = CustomizableSVG.Vertex.add @vertices[i].get('x'), @vertices[i].get('y')
      @vertices[i].on "change", @handleChange
    @vertices[i]
    
  handleChange: =>
    @render()
    
  # abstract methods
  
  parseVertices: =>
    @warnAboutAbstractMethod("parseVertices")
    []
    
  render: =>
    @warnAboutAbstractMethod("render")
      
  warnAboutAbstractMethod: (methodName) =>
    console.warn "#{methodName} is an abstract method. You should extend it in your subclass (#{@constructor.name})."
    