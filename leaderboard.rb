require 'json'

##
# This class represents leaderboard of high scores.

class Leaderboard 

  ## Creates a new leaderboard taking a hash of name : score pairs.
  # An ArgumentError is raised if the anything other than a hash is passed in
  def initialize( default_leader_board = {} )
    raise ArgumentError, 'Argument is not a Hash' unless default_leader_board.is_a? Hash
    default_leader_board.each { |name,score|  
      raise ArgumentError, 'Argument is not a Hash with name : score pairs' unless name.is_a? String
      raise ArgumentError, 'Argument is not a Hash with name : score pairs' unless score.is_a? Fixnum
    } 
    @scores = default_leader_board
  end

  def print
    puts self.to_s
  end

  ## Add a new 
  # uses the JSON format  
  def add_score(name,score)
    @scores[name] = score    
  end  

  def remove_score(name)
    @scores.delete(name)
  end

  ## Loads a leaderboard from a file
  # uses the JSON format 

  def load(filename)
    json_string = String.new
    File.open(filename, "r") { |f| 
      json_string += f.read 
    }
    @score = JSON.parse json_string 
  end

  def size
    @scores.size
  end

  def save(filename)
    json_string = @scores.to_json

    File.open(filename, "w") { |f| 
      f.puts json_string
    }
  end

  def to_s
    s = "Name :: Score\n"
    sorted_scores = @scores.sort_by { |name,score| score }

    sorted_scores.each { |e|
      s += "#{e[0]} :: #{e[1]}\n"  
    }
    s
  end
end
