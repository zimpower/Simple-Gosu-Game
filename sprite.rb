require "gosu"
require "./depth_constants"

class Sprite
  attr_accessor :name
  attr_accessor :x, :y
  attr_accessor :depth, :height, :width

  def initialize(game_window, image, depth = DepthOrder::Background)
    @game_window = game_window  
    @SpriteImage = image
    @depth = depth

    if game_window && image
      @valid_spite = true
    else
      @valid_spite = false
    end

    @height = @SpriteImage.height
    @width = @SpriteImage.width

    @x = @y = 0
  end

  def load(filename)
    @SpriteImage = Gosu::Image.new(@game_window,filename)
    @valid_spite = true  unless @SpriteImage == nil
    @height = @SpriteImage.height
    @width = @SpriteImage.width
  end

  def draw
    @SpriteImage.draw(@x,@y,@depth)  unless @valid_spite == false
  end

  # checks a sprite's position relative to the bounds it is set and adjusts accordingly
  def off_screen?
    return (@x < -@width or @x > @game_window.width or @y < -@height or @y > @game_window.height)
  end
end