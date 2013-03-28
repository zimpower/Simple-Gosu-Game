## Creates handles and destroys sprites
# 
require "gosu"
require "./sprite"
require "./player"

class Sprite_Handler
  attr_accessor :sprites

  def initialize(game_window )
    @game_window = game_window
    @sprites = []
    @params = {}
  end

  ## Update the positions and numbers of sprites on the screen
  def update

    # Iterate over every sprite we handle, updating their positions
    @sprites.each { |sp|

      # extract the sprite meta data fmor the @params hash
      params = @params[sp.name]

      # update the sprites position
      sp.x += params[:dx]
      sp.y += params[:dy]

      # Check the sprite is staying within its defined bounds
      check_bounds(sp,params)

      # does the sprite need to decelerate?
      if params[:decelerate]
        params[:dx]  *= params[:decelerate]
        params[:dy]  *= params[:decelerate]
      end

      # does this sprite need to be destroyed
      if sp.off_screen?
        @sprites.delete(sp)
        params[:num] -= 1
        puts "Deleting spite: #{sp.name}"
      end
    }

    # Check to see if we need to create new sprites
    @params.values.each do |p|
      # Only add a new instance of this sprite if we need too
      if p[:num] < p[:max_num]
        # use rand to randomly generate a sprite 
        if rand(1000) < p[:rarity]
          if sp = create_sprite(p)
            @sprites << sp
            p[:num] += 1
          end
        end
      end
    end    
  end

  # checks a sprite's position relative to the bounds it is set and adjusts accordingly
  def check_bounds(sp, params)
    if params[:xdisplay] == :wrap
      sp.x %= @game_window.width
    elsif params[:xdisplay] == :bound
      sp.x = (@game_window.width - sp.width) if sp.x > (@game_window.width - sp.width)
    elsif params[:ydisplay] == :wrap
      sp.y %= @game_window.height - sp.height
    elsif params[:ybound] == :bound
      sp.y = (@game_window.height - sp.height) if sp.y > (@game_window.height - sp.height)
    end
  end

  ## Creates a new sprite using the params passed in and adds it to the @sprite array
  def create_sprite (params)

    # TODO handle an error better
    sp = Sprite.new(@game_window, params[:image_filename])

    if sp == nil 
      return nil
    end

    # set the sprites name
    sp.name = params[:name]

    # set the starting x-position
    if params[:startx] == :random
      sp.x = rand(@game_window.width)
    elsif params[:startx] == :left
      sp.x = -sp.width
    elsif params[:startx] == :right
      sp.x = @game_window.width - sp.width
    elsif params[:startx].is_a? Numeric
      sp.x = params[:startx]
    else       
      sp.x = 0
    end

    # set the starting x-position
    if params[:starty] == :random
      sp.y = rand(@game_window.height)
    elsif params[:starty] == :top
      sp.y = -sp.height
    elsif params[:starty] == :bottom
      sp.y = @game_window.width - sp.width
    elsif params[:starty].is_a? Numeric
      sp.y = params[:starty]
    else
      sp.y = 0
    end

    # set the starting speed
    params[:startdx] ? params[:dx] = params[:startdx] : params[:dx] = 0
    params[:startdy] ? params[:dy] = params[:startdy] : params[:dy] = 0
    
    check_bounds(sp, params)

    # set sprite depth
    sp.depth = params[:depth] ? params[:depth] : 0

    # return the new sprite
    return sp
  end

  ## add a sprite
  def add(params)

    # Add this sprite parameter definition to our @params hash using it's name
    # as a key

    if params
      if params[:image_filename] && params [:name]
        # can i load the sound file?
        if params[:sound_filename]
          fx = Gosu::Sample.new(@game_window, params[:sound_filename])
          if fx 
            params[:sound] = fx
          end
        end

        # set some default values
        params[:startdx] ? params[:dx] = params[:startdx] : params[:dx] = 0
        params[:startdy] ? params[:dy] = params[:startdy] : params[:dy] = 0
        params[:depth] ? params[:depth] : 0
        params[:max_num] ? params[:max_num] : 1
        params[:rarity] ? params[:rarity] : 1
        params[:num] = 0

        @params[params[:name]] = params
        puts "add a new params: #{params.inspect}"
        return true
      end
    end
    return false
  end

  def handle_collisions(player)
    # Loop over each type=name of sprites
    @params.each do |name,p|

      # which sprites have we hit
      hit_sprites = @sprites.select do |s| 
        (s.name == name)  && (Gosu::distance(s.x, s.y, player.x, player.y) < p[:distance])
      end

      # handle each collision
      # eg change the score / lives / beep etc
      hit_sprites.each do |sp|
        player.score += p[:score]
        player.lives += p[:lives]
        
        @sprites.delete(sp)
        p[:num] -= 1
        puts "Collided with spite: #{sp.name}"
        
        if p[:sound] 
          p[:sound].play
        end
      end
    end
  end

  def draw
    @sprites.each { |sp| sp.draw }
  end
end

