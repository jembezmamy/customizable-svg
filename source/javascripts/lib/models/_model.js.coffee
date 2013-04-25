class CustomizableSVG.Model extends CustomizableSVG.EventDispatcher
  attr: null

  set: () =>
    newAttr = {}
    if arguments.length == 2
      newAttr[arguments[0]] = arguments[1]
    else
      newAttr = arguments[0]
      
    events = ""
    for name, value of newAttr
      if @attr[name] != value
        @attr[name] = value
        events += "change:#{name}"
        
    if events.length > 0
      @trigger "#{events} change"

  get: (name) =>
    @attr[name]