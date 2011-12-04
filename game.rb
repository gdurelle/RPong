require 'gosu'
require 'chipmunk'
require File.expand_path('./', "paddle.rb")
require File.expand_path('./', "ball.rb")

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "R-Pong"

    # Create our Space and set its damping
    # A damping of 0.8 causes the ship bleed off its force and torque over time
    # This is not realistic behavior in a vacuum of space, but it gives the game
    # the feel I'd like in this situation
    @space = CP::Space.new
    @space.damping = 0.8
    # Time increment over which to apply a physics "step" ("delta t")
    @dt = (1.0/60.0)
    
    # Create the Body for the Player;
    # mass, inertia
    left_body = CP::Body.new(10.0, 150.0)
    # In order to create a shape, we must first define it
    # Chipmunk defines 3 types of Shapes: Segments, Circles and Polys
    # We'll use s simple, 4 sided Poly for our Player (ship)
    # You need to define the vectors so that the "top" of the Shape is towards 0 radians (the right)
    shape_array = [CP::Vec2.new(-12.5, -75.0), CP::Vec2.new(-12.5, 75.0), CP::Vec2.new(12.5, 75.0), CP::Vec2.new(12.5, -75.0)]
    left_shape = CP::Shape::Poly.new(left_body, shape_array, CP::Vec2.new(0,0))
    @left_padle = Paddle.new(self, left_shape)
    @left_padle.warp(CP::Vec2.new(10, 10))
    
    right_body = CP::Body.new(10.0, 150.0)
    right_shape = CP::Shape::Poly.new(right_body, shape_array, CP::Vec2.new(0,0))
    @right_padle = Paddle.new(self, right_shape, Gosu::Color::RED)
    @right_padle.warp(CP::Vec2.new(605, 10))

    ball_body = CP::Body.new(10.0, 150.0)
    ball_shape_array = [CP::Vec2.new(-12.5, -12.5), CP::Vec2.new(-12.5, 12.5), CP::Vec2.new(12.5, 12.5), CP::Vec2.new(12.5, -12.5)]
    ball_shape = CP::Shape::Poly.new(ball_body, ball_shape_array, CP::Vec2.new(0,0))
    @ball = Ball.new(self, ball_shape)
    @ball.warp(CP::Vec2.new(320, 240))

    @space.add_body(left_body)
    @space.add_shape(left_shape)

    @space.add_body(right_body)
    @space.add_shape(right_shape)

    @space.add_body(ball_body)
    @space.add_shape(ball_shape)

    # The collision_type of a shape allows us to set up special collision behavior
    # based on these types.  The actual value for the collision_type is arbitrary
    # and, as long as it is consistent, will work for us; of course, it helps to have it make sense
    @left_padle.shape.collision_type = :paddle
    right_shape.collision_type = :paddle
    ball_shape.collision_type = :ball

    # Here we define what is supposed to happen when a Player (ship) collides with a Star
    # I create a @remove_shapes array because we cannot remove either Shapes or Bodies
    # from Space within a collision closure, rather, we have to wait till the closure
    # is through executing, then we can remove the Shapes and Bodies
    # In this case, the Shapes and the Bodies they own are removed in the Gosu::Window.update phase
    # by iterating over the @remove_shapes array
    # Also note that both Shapes involved in the collision are passed into the closure
    # in the same order that their collision_types are defined in the add_collision_func call
    @space.add_collision_func(:paddle, :ball) do |paddle_shape, ball_shape|
      @ball.change_direction
      @font.draw("Collision", 10, 30, 1, 1.0, 1.0, 0xffffff00)
    end

    # Here we tell Space that we don't want one star bumping into another
    # The reason we need to do this is because when the Player hits a Star,
    # the Star will travel until it is removed in the update cycle below
    # which means it may collide and therefore push other Stars
    # To see the effect, remove this line and play the game, every once in a while
    # you'll see a Star moving
    @space.add_collision_func(:ball, :ball, &nil)

    # text
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def update

    @ball.shape.body.reset_forces

    if button_down? Gosu::KbSpace
      @ball.launch unless @ball.launched
    end

    if button_down? Gosu::KbQ
      @left_padle.up
    end
    if button_down? Gosu::KbA
      @left_padle.down
    end

    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0
      @right_padle.up
    end
    if button_down? Gosu::KbDown
      @right_padle.down
    end

    # Perform the step over @dt period of time
    # For best performance @dt should remain consistent for the game
    @space.step(@dt)
  end

  def draw
    @left_padle.draw
    @right_padle.draw

    # @font.draw("Distance LEFT: #{Gosu::distance(@left_padle.x, @left_padle.y, @ball.x, @ball.y)}", 10, 10, 1, 1.0, 1.0, 0xffffff00)
    # @font.draw("Distance RIGHT: #{Gosu::distance(@right_padle.x, @right_padle.y, @ball.x, @ball.y)}", 10, 30, 1, 1.0, 1.0, 0xffffff00)

    # if @ball.launched
    #   # if Gosu::distance(@left_padle.x, @left_padle.y, @ball.x, @ball.y) <= 10 and @ball.direction < 0
    #   if (@ball.y >= @left_padle.y and @ball.y <= @left_padle.y+@left_padle.height) and @ball.x <= @left_padle.x + @left_padle.width
    #     @ball.change_direction
    #   # elsif Gosu::distance(@right_padle.x, @right_padle.y, @ball.x, @ball.y) <= 10 and @ball.direction > 0
    # elsif (@ball.y >= @right_padle.y and @ball.y <= @right_padle.y+@right_padle.height) and @ball.x >= @right_padle.x - @right_padle.width
    #     @ball.change_direction
    #   else 
    #     @ball.move
    #   end
    # end

    if @ball.launched
      @ball.move
    end

    @ball.draw
  end

  # override
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

end

# LAUNCH THE GAME WINDOW
window = GameWindow.new
window.show