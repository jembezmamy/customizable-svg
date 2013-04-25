class CustomizableSVG.Edge extends CustomizableSVG.Model
  @all: null
  
  @add: (v1, v2, length) ->
    @all ||= []
    @find(v1, v2) || @all[@all.length] = new CustomizableSVG.Edge(v1, v2, length)
    
  @find: (v1, v2) ->
    for edge in @all
      return edge if (edge.get("v1") == v1 && edge.get("v2") == v2) || (edge.get("v2") == v1 && edge.get("v1") == v2)
    null
  
  
  calculateLength: '' # dynamically generated function
  angle: 0
  
  constructor: (v1, v2, lengthFormula) ->
    @attr = v1: v1, v2: v2
    @angle = Math.atan2 v2.get("y") - v1.get("y"), v2.get("x") - v1.get("x")
    @sin = Math.sin(@angle)
    @cos = Math.cos(@angle)
    @parseLengthFormula lengthFormula
    v1.on "change", @handleVertexChange
    v2.on "change", @handleVertexChange
    
  parseLengthFormula: (formula) =>
    for name of CustomizableSVG.Measurement.all
      if formula.match name
        CustomizableSVG.Measurement.find(name).on "change", @handleMeasurementChange
      formula = formula.replace name, "CustomizableSVG.Measurement.find('#{name}').get('value')"
    eval "this.calculateLength = function() {return #{formula}}"
    
  update: =>
    length = @calculateLength()
    if @attr.v1.get('version') > @attr.v2.get("version")
      @attr.v2.set
        x: @attr.v1.get("x") + @cos*length
        y: @attr.v1.get("y") + @sin*length
        version: @attr.v1.get('version')
    else if @attr.v1.get('version') < @attr.v2.get("version")
      @attr.v1.set
        x: @attr.v2.get("x") - @cos*length
        y: @attr.v2.get("y") - @sin*length
        version: @attr.v2.get('version')
    
  handleVertexChange: =>
    @update()
    
  handleMeasurementChange: =>
    @attr.v1.set version: @attr.v2.get('version')+1
    @update()