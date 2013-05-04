class CustomizableSVG.ElasticEdge extends CustomizableSVG.Edge
  
  constructor: (v1, v2, params = {}) ->
    @length = Math.sqrt Math.pow(v2.get('x')-v1.get('x'), 2) + Math.pow(v2.get('y')-v1.get('y'), 2)
    super(v1, v2, params)
    
  