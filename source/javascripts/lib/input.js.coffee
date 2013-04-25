class CustomizableSVG.Input extends CustomizableSVG.EventDispatcher
  name: null
  type: null

  constructor: (placeholder) ->
    @$placeholder = $(placeholder)
    @name = @$placeholder.attr "personalizable:name"
    @type = "number"
    @buildInput()

  getValue: =>
    @$input.val()

  buildInput: =>
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
      
    @$input = $(document.createElementNS("http://www.w3.org/1999/xhtml", "input")).attr type: 'number'
    @$input.attr style: "position: absolute; display: block; left: 0; top: 0; bottom: 0; right: 0; margin: 0; -webkit-transform: translate(20px, 17px)"
    @$input.on "change", @handleChange
    @$input.appendTo body
    
    @$placeholder.replaceWith(foreignObject)

  handleChange: (e) =>
    @trigger "change", this
