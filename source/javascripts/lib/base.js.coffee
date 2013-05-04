class CustomizableSVG.Base
  inputs: null

  constructor: ->
    @buildMeasurements()
    @buildElements()
    @buildInputs()

  buildMeasurements: =>
    $('[customizable\\:name]').each (i, el) =>
      CustomizableSVG.Measurement.add $(el).attr("customizable:name")
      
  buildElements: =>
    $('[customizable\\:lengths], [customizable\\:points]').each (i, el) =>
      elementClass = switch $(el)[0].nodeName
        when "line" then CustomizableSVG.Elements.Line
        when "polygon" then CustomizableSVG.Elements.Polygon
        when "text" then CustomizableSVG.Elements.Text
      new elementClass(el)
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
