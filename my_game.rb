#!/usr/bin/env ruby -wKU
require 'rubygems'
require 'gosu'
require './player'
require "./sprite_handler"
require './leaderboard'
require './inputwindow'
require "./depth_constants"

class MyGame < Gosu::Window
  def initialize
    super(1600,1200,false)
    @background  = Gosu::Image.new(self, 'media/YoshiBackground.png')
    @font        = Gosu::Font.new(self, Gosu::default_font_name, 24)
    self.caption = "Toby's Yoshi Catch"

    @playing     = false
    @pause       = nil
    @leaderboard = Leaderboard.new
    @leaderboard.load("leaderboard/leaderboard.json")
  end

  def start_game
    @player      = Player.new(self)
    @sprite_handler = Sprite_Handler.new(self)

    sprite_defs = []
    sprite_defs << {
      :image_filename => "media/YoshiEggSprite.png",
      :sound_filename => "media/eggbeep.wav",
      :startx => :random,
      :starty => :top,
      :startdx => 0,
      :startdy => 7,
      :xdisplay => :bound,
      :ydisplay => :nil,
      :decelerate => false,
      :xdepth => DepthOrder::Friend,
      :max_num => 10,
      :rarity => 40,
      :distance => 70,
      :lives => 0,
      :score => 10,
      :name => :egg 
    }

    sprite_defs << {
      :image_filename => "media/YoshiSpikeBallSprite.png",
      :sound_filename => "media/spikeballbeep.wav",
      :startx => :random,
      :starty => :top,
      :startdx => 0,
      :startdy => 10,
      :xdisplay => :bound,
      :ydisplay => nil,
      :decelerate => false,
      :xdepth => DepthOrder::Enemy,
      :max_num => 3,
      :rarity => 20,
      :distance => 70,
      :lives => 0,
      :score => -10,
      :name => :spikeball
    }

    sprite_defs << {
      :image_filename => "media/YoshiMegaSpikeBallSprite.png",
      :sound_filename => "media/megaballbeep.wav",
      :startx => :random,
      :starty => :top,
      :startdx => 0,
      :startdy => 5,
      :xdisplay => :bound,
      :ydisplay => nil,
      :decelerate => false,
      :xdepth => DepthOrder::Enemy,
      :max_num => 1,
      :rarity => 10,
      :distance => 70,
      :lives => -1,
      :score => 0,
      :name => :megaspikeball
    }

    sprite_defs << {
      :image_filename => "media/birdsprite.png",
      :sound_filename => "media/eggbeep.wav",
      :startx => :left,
      :starty => 200,
      :startdx => 15,
      :startdy => 0,
      :xdisplay => nil,
      :ydisplay => nil,
      :decelerate => 0.99,
      :xdepth => DepthOrder::Friend,
      :max_num => 1,
      :rarity => 1,
      :distance => 70,
      :lives => 1,
      :score => 25,
      :name => :bird
    }

    sprite_defs.each { |spd| @sprite_handler.add(spd) }

    @pause       = false
    @playing     = true
  end

  def update
    if ( @pause == false && @playing == true )
      if button_down? Gosu::Button::KbLeft
        @player.move_left
      elsif button_down? Gosu::Button::KbRight
        @player.move_right
      elsif button_down? Gosu::Button::KbUp
        @player.move_up
      elsif button_down? Gosu::Button::KbDown
        @player.move_down
      end

      @sprite_handler.update
      @sprite_handler.handle_collisions(@player)
      @player.check_lives
    end
  end

  def draw
    @background.draw(0,0,0)
    if @playing
      @sprite_handler.draw
      @player.draw

      if @pause == true then
        @font.draw("Paused: #{@player.score}", 10, 10, 10, 1.0, 1.0, 0xffffff00) 
      else 
        @font.draw("Score: #{@player.score}  Lives: #{@player.lives}   P: Pause   S: Start   Q: Quit Game   Esc: Quit App", 
        10, 10, 1, 1.0, 1.0, 0xffffff00)
      end
    else
      @font.draw("P: Pause   S: Start   Q: Quit Game   Esc: Quit App", 10, 10, 1, 1.0, 1.0, 0xffffff00)      
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      quit()
    elsif id == Gosu::Button::KbP
      @pause     = !@pause

    elsif id == Gosu::Button::KbS
      if ( @playing == false )
        start_game
      end

    elsif id == Gosu::Button::KbQ
      if ( @playing == true )
        @playing = false
        @leaderboard.add_score("Toby", @player.score)
        @leaderboard.save("leaderboard/leaderboard.json")
      end
    end
  end

  def quit
    if @player
      @leaderboard.add_score("Toby", @player.score)
      @leaderboard.save("leaderboard/leaderboard.json")
    end

    puts
    @leaderboard.print
    puts

    close
  end
end

window           = MyGame.new
window.show
