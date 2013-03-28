require "./leaderboard"

##
# This class represents leaderboard of high scores.

describe Leaderboard do
  it "keeps a list of the highscores" do
    lb = Leaderboard.new({})
    expect(lb.size).to eq(0)
  end

  it "keeps is constructed with a hash table of names and scores" do
    expect{ Leaderboard.new(0) }.to raise_error(ArgumentError)
    expect{ Leaderboard.new({"bob"=>"foo"}) }.to raise_error(ArgumentError)
  end

  it "can have high scores added to it" do
    lb = Leaderboard.new({})
    lb.add_score("toby", 1)
    expect(lb.size).to eq(1)
  end

  it "can have high scores removed from it" do
    lb = Leaderboard.new({})
    lb.add_score("toby", 1)
    lb.add_score("oli", 2)
    lb.remove_score("toby")
    expect(lb.size).to eq(1)
  end

  it "to_s: can return a sorted string of scores" do
    lb = Leaderboard.new("xavi"=>10)
    lb.add_score("oli",2)
    lb.add_score("toby",5)
    s = lb.to_s
    expect(s).to eq("Name :: Score\noli :: 2\ntoby :: 5\nxavi :: 10\n")
  end

  it "loads a raises an error if the lederboard doesn't exits" do
    expect{ Leaderboard.new({}).load("random file") }.to raise_error(IOError)
  end

  it "loads a leadaerboard from a file" do
    lb = Leaderboard.new.load("leaderboard/test_leaderboard.json")

    s = lb.to_s
    expect(s).to eq("Name :: Score\noli :: 2\ntoby :: 5\nxavi :: 10\n")
  end

end
