class Paddle
  
  # attr_reader :x, :y, :width, :height
  attr_reader :shape
  
  def initialize(window, shape, color = Gosu::Color::BLUE)
    @shape = shape
    @shape.body.p = CP::Vec2.new(0.0, 0.0) # position
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
    
    # @x = @y = 0.0
    @width = 25
    @height = 150
    @color = color
    @screen = window
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
  
  def down
    # @y += 10 unless (@y+@height+10) >= @screen.height
    @shape.body.p.y += 10 unless @shape.body.p.y+ @height+10 >= @screen.height
  end
  
  def up
    # @y -= 10 unless @y <= 10
    @shape.body.p.y -= 10 unless @shape.body.p.y <= 10
  end
  
end