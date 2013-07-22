class CustomizableSVG.Base
  inputs: null

  constructor: ->
    @buildMeasurements()
    @buildElements()
    @buildInputs()

  buildMeasurements: =>
    $('[customizable\\:name]').each (i, el) =>
      measurement = CustomizableSVG.Measurement.add $(el).attr("customizable:name")
      measurement.on "after:change", @handleMeasurementChange
      
  buildElements: =>
    $('[customizable\\:lengths], [customizable\\:points]').each (i, el) =>
      type = $(el)[0].nodeName
      className = type.substr(0,1).toUpperCase() + type.substr(1)
      new CustomizableSVG.Elements[className](el)
    # inter-element bindings cannot be created before all elements are initialized
    CustomizableSVG.Elements.Base.buildBindings()

  buildInputs: =>
    @inputs = []
    $('[customizable\\:number-input]').each (i, el) =>
      input = new CustomizableSVG.Input(el)
      input.on "change", @handleInputChange
      @inputs.push input

  handleInputChange: (input) =>
    measurement = CustomizableSVG.Measurement.find input.name
    name = switch input.type
      when "number" then "value"
      when "unit" then "unit"
    measurement.set name, input.getValue()
    
  handleMeasurementChange: =>
    CustomizableSVG.Vertex.resetVersions()
    CustomizableSVG.Edge.resetVersions()
