class CustomizableSVG.Edge extends CustomizableSVG.Model
  @all: null
  
  @add: (v1, v2, params = {}) ->
    @all ||= []
    edgeClass = switch params.elastic
      when true then CustomizableSVG.ElasticEdge
      else CustomizableSVG.RigidEdge
    @find(v1, v2) || @all[@all.length] = new edgeClass(v1, v2, params)
    
  @find: (v1, v2) ->
    for edge in @all
      return edge if (edge.get("v1") == v1 && edge.get("v2") == v2) || (edge.get("v2") == v1 && edge.get("v1") == v2)
    null
    
  @resetVersions: ->
    for edge in @all
      edge.set version: 0
  
  
  calculateLength: null # dynamically generated function
  length: 0 # length fallback if no calculateLength function is provided
  angle: 0
  
  constructor: (v1, v2, params = {}) ->
    @attr = v1: v1, v2: v2, version: 0
    @angle = Math.atan2 v2.get("y") - v1.get("y"), v2.get("x") - v1.get("x")
    @sin = Math.sin(@angle)
    @cos = Math.cos(@angle)
      
    v1.on "change", @handleVertexChange
    v2.on "change", @handleVertexChange
    
    v1.addEdge this
    v2.addEdge this
    
  suggestPositionFor: (vertex, version, ignoredVertices = []) =>
    if ignoredVertices.indexOf(@get('v1')) != -1 || ignoredVertices.indexOf(@get('v2')) != -1
      return false
    length = if @calculateLength then @calculateLength() else @length
    if vertex == @get('v1')
      base = @get("v2")
      direction = -1
    else
      base = @get("v1")
      direction = 1
    if base.get("version") < version
      position = base.getSuggestedPosition(version, [vertex].concat ignoredVertices)
    if position
      x = position.x
      y = position.y
    else
      x = base.get("x")
      y = base.get("y")
    x: x + direction*@cos*length
    y: y + direction*@sin*length
    length: length
    
  update: =>
    @set version: Math.max @attr.v1.get('version'), @attr.v2.get('version')
    
  handleVertexChange: =>
    @update()