class CustomizableSVG.Vertex extends CustomizableSVG.Model
  @all: null
  
  @add: (x, y) ->
    @all ||= []
    @find(x, y) || @all[@all.length] = new CustomizableSVG.Vertex(x, y, true)
    
  @find: (x, y) ->
    x = Number(x)
    y = Number(y)
    for vertex in @all
      return vertex if vertex.get('x') == x && vertex.get('y') == y
    null
    
  @resetVersions: ->
    for vertex in @all
      vertex.set version: 0
    
  rigidEdges: null
  elasticEdges: null
  
  constructor: (x, y, inCollection = false) ->
    @inCollection = inCollection
    @attr = x: Number(x), y: Number(y), version: 0
    @rigidEdges = []
    @elasticEdges = []
    
  addEdge: (edge) =>
    if edge instanceof CustomizableSVG.RigidEdge
      @rigidEdges.push edge
    else
      @elasticEdges.push edge
    edge.on 'change', @handleEdgeChange
    
  update: =>
    @set @getSuggestedPosition()
      
  getSuggestedPosition: (version, ignoredVertices) =>
    if @rigidEdges.length
      @calculatePosition true, version, ignoredVertices
    else
      @calculatePosition false, version, ignoredVertices
  
  calculatePosition: (rigid, version = null, ignoredVertices) =>
    edges = if rigid then @rigidEdges else @elasticEdges
    total = {x: 0, y: 0, count: 0}
    unless version?
      version = 0
      for edge in edges
        version = Math.max version, edge.get("version")
    for edge in edges
      if (!rigid || version == edge.get('version'))
        position = edge.suggestPositionFor this, version, ignoredVertices
        if position 
          el = document.createElementNS "http://www.w3.org/2000/svg", "circle"
          $(el).attr(cx: position.x, cy: position.y, r: 2, fill: "red").appendTo("svg")
          $(el).remove()
          position.length ||= 1
          total.x += position.x / position.length
          total.y += position.y / position.length
          total.count += 1 / position.length
    if total.count
      total.x /= total.count
      total.y /= total.count
      x: total.x, y: total.y, version: version
    
      
    
  handleEdgeChange: (edge) =>
    @update() if edge.get('version') > @get('version')