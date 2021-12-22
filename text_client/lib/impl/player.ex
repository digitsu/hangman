defmodule TextClient.Impl.Player do
  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: { game, tally }

  @spec start(game) :: :ok
  def start(game) do
    IO.puts "Started Hangman on #{node()} process #{inspect(game)}"
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  # @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

  @spec interact(state) :: :ok

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts "Congratulations! You won."
  end
  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts "Sorry you lost ... the word was #{tally.letters |> Enum.join}"
  end

  def interact({game, tally}) do
    # get state, give feedback on state, display the curr word, and get the next guess, make move, recurse
    IO.puts feedback_for(tally)
    IO.puts current_word(tally)
    tally = Hangman.make_move(game, get_guess())
    interact({game, tally})
  end

  # @type state :: :initializing | :good_guess | :bad_guess | :already_used
  def feedback_for(tally = %{game_state: :initializing}) do
    "Welcome! I'm thinking of a #{tally.letters |> length} letter word"
  end

  def feedback_for(_tally = %{game_state: :good_guess}), do: "Good guess!"
  def feedback_for(_tally = %{game_state: :bad_guess}), do: "Sorry, that letter is wrong"
  def feedback_for(_tally = %{game_state: :already_used}), do: "You already guessed that letter"

  def current_word(tally) do
    [
    "Word so far: ", tally.letters |> Enum.join(" "),
    "    turns left: ", tally.turns_left |> to_string,
    "    used so far: ", tally.used |> Enum.join(","),
    ]
  end

  def get_guess() do
    IO.gets( "Next letter: ")
    |> String.trim()
    |> String.downcase()
  end
end
