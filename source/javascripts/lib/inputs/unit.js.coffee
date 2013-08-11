class CustomizableSVG.Inputs.Unit extends CustomizableSVG.Inputs.Base
  
  buildInput: =>
    input = $(document.createElementNS("http://www.w3.org/1999/xhtml", "select"))
    for unit in ["mm", "cm", "in", "px", "pt", "pc"]
      @buildOption(unit).appendTo input
    input
    
  buildOption: (name) =>
    $(document.createElementNS("http://www.w3.org/1999/xhtml", "option")).text(name)