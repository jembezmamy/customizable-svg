class CustomizableSVG.Base
  inputs: null
  elements: null

  constructor: ->
    @buildMeasurements()
    @buildElements()
    @buildInputs()

  buildMeasurements: =>
    $('[customizable\\:name]').each (i, el) =>
      CustomizableSVG.Measurement.add $(el).attr("customizable:name")
      
  buildElements: =>
    @elements = []
    $('[customizable\\:length]').each (i, el) =>
      elementClass = switch $(el)[0].nodeName
        when "line" then CustomizableSVG.Line
      @elements.push new elementClass(el)

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
