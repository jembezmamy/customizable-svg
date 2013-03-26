class CustomizableSVG.Base
  inputs: null

  constructor: ->
    @buildInputs()

  buildInputs: =>
    @inputs = []
    $('[personalizable\\:number-input]').each (i, el) =>
      @inputs.push new CustomizableSVG.Input(el)
