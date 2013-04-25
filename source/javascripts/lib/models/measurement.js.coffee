class CustomizableSVG.Measurement extends CustomizableSVG.Model
  @all: null
  
  @add: (name) ->
    @all ||= {}
    @all[name] ||= new CustomizableSVG.Measurement()
    
  @find: (name) ->
    @all[name]

  constructor: ->
    @attr =
      value: 0
      unit: ''
      
  set: (name, value) =>
    if name == 'value'
      value = Number(value)
    super name, value