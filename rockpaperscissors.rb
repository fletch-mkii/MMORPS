class RockPaperScissors
  attr_reader :player_choice, :cpu_choice

  def initialize(player_choice)
    @player_choice = player_choice
    @cpu_choice = ["Rock","Paper","Scissors"].sample
  end

  def winner?
    return "tie" if @player_choice == @cpu_choice
    return "Player" if \
    @player_choice == "Rock" && @cpu_choice == "Scissors" ||\
    @player_choice == "Paper" && @cpu_choice == "Rock" ||\
    @player_choice == "Scissors" && @cpu_choice == "Paper"
    return "CPU" if \
    @cpu_choice == "Rock" && @player_choice == "Scissors" ||\
    @cpu_choice == "Paper" && @player_choice == "Rock" ||\
    @cpu_choice == "Scissors" && @player_choice == "Paper"
  end
end
