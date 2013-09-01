class CustomizableSVG.Inputs.Base extends CustomizableSVG.EventDispatcher

  constructor: (placeholder) ->
    @$placeholder = $(placeholder)
    @render()

  getValue: =>
    @$input.val()

  render: =>
    foreignObject = $(document.createElementNS('http://www.w3.org/2000/svg', "foreignObject"))
    foreignObject.attr
      x: @$placeholder.attr('x')
      y: @$placeholder.attr('y')
      width: @$placeholder.attr('width')
      height: @$placeholder.attr('height')

    html = $(document.createElementNS("http://www.w3.org/1999/xhtml", "html"))
    html.attr xmlns: "http://www.w3.org/1999/xhtml"
    html.appendTo foreignObject

    body = $(document.createElementNS("http://www.w3.org/1999/xhtml", "body")).attr style: "margin: 0; position: relative; height: #{@$placeholder.attr('height')}px"
    body.appendTo html
      
    @$input = @buildInput()
    @$input.attr style: "position: absolute; display: block; left: 0; top: 0; bottom: 0; right: 0; margin: 0;"
    @$input.on "change", @handleChange
    if @$placeholder.attr("customizable:default")
      @$input.val @$placeholder.attr("customizable:default")
    @$input.appendTo body
    
    @$placeholder.replaceWith(foreignObject)

  handleChange: (e) =>
    @trigger "change", this
  
  # abstract methods
  
  buildInput: =>
    console.warn "buildInput is an abstract method. You should extend it in your subclass (#{@constructor.name})."
