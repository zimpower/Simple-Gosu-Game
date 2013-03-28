require "./sprite.rb"

LIVES = 1
RETRY = 1


class Player < Sprite
  attr_accessor :score
  attr_accessor :lives

  def initialize(game_window)
    super(game_window,'media/YoshiDanceSprite.png')
    @Eggbeep = Gosu::Sample.new(@game_window, "media/eggbeep.wav")
    @BallBeep = Gosu::Sample.new(@game_window, "media/spikeballbeep.wav")
    @MegaBallBeep = Gosu::Sample.new(@game_window, "media/megaballbeep.wav")

    @x = 800
    @y = 915
    @score = 0

    @lives = LIVES
    @retry = RETRY
  end

  def move_left
    @x -= [15, @x].min
  end

  def move_right
    @x += 15
    if @x > ( 1600 - @width )
      @x = 1600 - @width
    end
  end

  def move_up
    @y -= 15
    if ( @y < 0 )
      @y = 0
    end
  end

  def move_down
    @y += 15
    if @y > (1200 - @height )
      @y = 1200 - @height
    end
  end

  def catch_bird(birds)
    if birds.reject! {|bird| Gosu::distance(@x, @y, bird.x, bird.y) < 70 } then
      @lives += 1
      @score += 10
      @Eggbeep.play
    end
  end

  def check_lives
    if @lives <= 0 then
      if @retry == 3 then
        load('media/penguinsprite.png')
        @retry -= 1
        @lives = LIVES
      elsif @retry == 2 then
        load('media/GiraffeSprite.png')
        @retry -= 1
        @lives = LIVES
      elsif @retry == 1 then
        load('media/DuckieSprite.png')
        @retry -= 1
        @lives = LIVES
      else
        @game_window.quit()
      end
    end
  end
end