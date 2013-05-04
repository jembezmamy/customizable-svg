class CustomizableSVG.RigidEdge extends CustomizableSVG.Edge
  
  constructor: (v1, v2, params = {}) ->
    super(v1, v2, params)
    if params.length
      @parseLengthFormula params.length
      
  parseLengthFormula: (formula) =>
    for name of CustomizableSVG.Measurement.all
      if formula.match name
        CustomizableSVG.Measurement.find(name).on "change", @handleMeasurementChange
      formula = formula.replace name, "CustomizableSVG.Measurement.find('#{name}').get('value')"
    eval "this.calculateLength = function() {return #{formula}}"
  
  # update: =>
#     length = if @calculateLength then @calculateLength() else 0
#     if @attr.v1.get('version') > @attr.v2.get("version")
#       @attr.v2.set
#         x: @attr.v1.get("x") + @cos*length
#         y: @attr.v1.get("y") + @sin*length
#         version: @attr.v1.get('version')
#     else if @attr.v1.get('version') < @attr.v2.get("version")
#       @attr.v1.set
#         x: @attr.v2.get("x") - @cos*length
#         y: @attr.v2.get("y") - @sin*length
#         version: @attr.v2.get('version')     
  
  handleMeasurementChange: =>
    @attr.v1.set version: @attr.v2.get('version')+1
    @update()