class Ball
  
  attr_reader :shape, :launched, :direction
  
  def initialize(window, shape)
    @shape = shape
    @shape.body.p = CP::Vec2.new(0.0, 0.0) # position
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
    
    # Keep in mind that down the screen is positive y, which means that PI/2 radians,
    # which you might consider the top in the traditional Trig unit circle sense is     actually
    # the bottom; thus 3PI/2 is the top
    @shape.body.a = (3*Math::PI/2.0) # angle in radians; faces towards top of screen
    
    
    @width = 25
    @height = 25
    @color = color = Gosu::Color::WHITE
    @screen = window
    @launched = false
    @direction = -5
  end
  
  def draw
    # @screen.draw_quad(@x, @y, @color, @x+@width, @y, @color, @x+@width, @y+@height, @color, @x, @y+@height, @color, z = 0, mode = :default)
    @screen.draw_quad(@shape.body.p.x, @shape.body.p.y, @color, @shape.body.p.x+@width, @shape.body.p.y, @color, @shape.body.p.x+@width, @shape.body.p.y+@height, @color, @shape.body.p.x, @shape.body.p.y+@height, @color, z = 0, mode = :default)
  end
  
  # set position
  def warp(vector)
    # @x, @y = x, y
    @shape.body.p = vector
  end
  
  def launch
    @launched = true
  end
  
  def move
    @shape.body.p.x += @direction
  end
  
  def change_direction
    @direction = -@direction
    move
  end
  
end