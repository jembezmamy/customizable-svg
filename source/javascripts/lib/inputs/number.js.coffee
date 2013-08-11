class CustomizableSVG.Inputs.Number extends CustomizableSVG.Inputs.Base
  
  constructor: (placeholder) ->
    super(placeholder)
    @name = @$placeholder.attr "customizable:number-input"
  
  buildInput: =>
    $(document.createElementNS("http://www.w3.org/1999/xhtml", "input")).attr type: 'number'