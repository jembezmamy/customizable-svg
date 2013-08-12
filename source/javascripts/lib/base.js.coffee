class CustomizableSVG.Base extends CustomizableSVG.EventDispatcher
  @instance: null
  @getInstance: ->
    @instance || @instance = new CustomizableSVG.Base()
    
  inputs: null
  $svg: null
  $canvas: null
  $scale: null
  $scaleLabel: null
  $scaleLine: null
  
  originalViewBox: null
  unit: "mm"

  init: =>
    @$svg = $("svg").first()
    @on "change:unit", @handleUnitChange
    
    @buildMeasurements()
    @buildElements()
    @buildInputs()
    @initScale()
    @initSize()
    
    
  setUnit: (unit) =>
    return if unit == @unit
    @unit = unit
    @trigger "change:unit change", this
    

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
      
      
    
  initScale: =>
    $defs = $(document.createElementNS('http://www.w3.org/2000/svg', "defs")).appendTo @$svg
    $marker = $(document.createElementNS('http://www.w3.org/2000/svg', "marker")).appendTo $defs
    $marker.attr id: "customizable-scale-marker", viewBox: "0 0 1 5", stroke: "black", refX: 0.5, refY: 2.5, markerWidth: 1, markerHeight: 9
    $(document.createElementNS('http://www.w3.org/2000/svg', "line")).attr(x1: 0.5, y1: 0, x2: 0.5, y2: 5).appendTo $marker
    @$scale = $(document.createElementNS('http://www.w3.org/2000/svg', "g")).appendTo @$svg
    @$scaleLine = $(document.createElementNS('http://www.w3.org/2000/svg', "line")).appendTo @$scale
    @$scaleLine.attr stroke: "black", "marker-start": "url(#customizable-scale-marker)", "marker-end": "url(#customizable-scale-marker)"
    @$scaleLabel = $(document.createElementNS('http://www.w3.org/2000/svg', "text")).appendTo @$scale
    @$scaleLabel.attr "text-anchor": "middle", style: "font-size: 10px"
    @updateScale()
  
  updateScale: =>
    h = @$svg.get(0).height
    length = switch @unit
      when "mm", "px", "pt" then 10
      else 1
    @$scaleLine.attr
      x1: 0
      y1: 5.5
      x2: length  + @unit
      y2: 5.5
    @$scaleLabel.attr(x: (length / 2)+@unit).text [length, @unit].join(" ")
    
  
  
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
    scaleY = svgViewBox[3] - svgViewBox[1] - 20
    @$scale.attr transform: "translate(10, #{scaleY})"
    
    

  handleInputChange: (input) =>
    if input instanceof CustomizableSVG.Inputs.Number
      measurement = CustomizableSVG.Measurement.find input.name
      measurement.set "value", input.getValue()
    else
      @setUnit input.getValue()
    
  handleMeasurementChange: =>
    CustomizableSVG.Vertex.resetVersions()
    CustomizableSVG.Edge.resetVersions()
    @adjustSize()
    
  handleUnitChange: =>
    @adjustSize()
    @updateScale()
