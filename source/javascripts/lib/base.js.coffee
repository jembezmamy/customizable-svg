class CustomizableSVG.Base extends CustomizableSVG.EventDispatcher
  @instance: null
  @getInstance: ->
    @instance || @instance = new CustomizableSVG.Base()
    
  inputs: null
  $svg: null
  $canvas: null
  unit: "mm"
  
  originalViewBox: null

  init: =>
    @$svg = $("svg").first()
    @buildMeasurements()
    @buildElements()
    @buildInputs()
    @initSize()

  buildMeasurements: =>
    $('[customizable\\:number-input]').each (i, el) =>
      measurement = CustomizableSVG.Measurement.add $(el).attr("customizable:number-input")
      measurement.on "after:change", @handleMeasurementChange
      
  buildElements: =>
    @$canvas = $(document.createElementNS('http://www.w3.org/2000/svg', "svg"))
    $elements = $('[customizable\\:lengths], [customizable\\:points]')
    $elements.first().before @$canvas
    $elements.each (i, el) =>
      $(el).appendTo @$canvas
      type = $(el)[0].nodeName
      className = type.substr(0,1).toUpperCase() + type.substr(1)
      new CustomizableSVG.Elements[className](el)
    # inter-element bindings cannot be created before all elements are initialized
    CustomizableSVG.Elements.Base.buildBindings()

  buildInputs: =>
    @inputs = []
    $('[customizable\\:number-input], [customizable\\:unit-input]').each (i, el) =>
      if $(el).is('[customizable\\:number-input]')
        input = new CustomizableSVG.Inputs.Number(el)
      else
        input = new CustomizableSVG.Inputs.Unit(el)
      input.on "change", @handleInputChange
      @inputs.push input
  
  initSize: =>
    @originalViewBox = @$svg.attr("viewBox").split(/\s/)
    for value, i in @originalViewBox
      @originalViewBox[i] = parseInt value
    @$canvas.attr
      preserveAspectRatio: "none"
      x: CustomizableSVG.Vertex.min("x")
      y: CustomizableSVG.Vertex.min("y")
    @$svg.attr preserveAspectRatio: "none"
    @adjustSize()
      
  adjustSize: =>
    x = Math.floor CustomizableSVG.Vertex.min("x")
    y = Math.floor CustomizableSVG.Vertex.min("y")
    width = Math.ceil CustomizableSVG.Vertex.max("x") - x
    height = Math.ceil CustomizableSVG.Vertex.max("y") - y
    @$canvas.attr viewBox: [x, y, width, height].join(" "), width: width + @unit, height: height + @unit
    svgViewBox = @originalViewBox[0..1]
    canvasBB = @$canvas.get(0).getBoundingClientRect()
    svgViewBox.push Math.max @originalViewBox[2], canvasBB.width + canvasBB.left
    svgViewBox.push Math.max @originalViewBox[3], canvasBB.height + canvasBB.top
    @$svg.attr viewBox: svgViewBox.join(" "), width: svgViewBox[2], height: svgViewBox[3]
  

  handleInputChange: (input) =>
    if input instanceof CustomizableSVG.Inputs.Number
      measurement = CustomizableSVG.Measurement.find input.name
      measurement.set "value", input.getValue()
    else
      @unit = input.getValue()
      @trigger "change:unit", this
    @adjustSize()
    
  handleMeasurementChange: =>
    CustomizableSVG.Vertex.resetVersions()
    CustomizableSVG.Edge.resetVersions()
