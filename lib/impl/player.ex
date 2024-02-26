defmodule Impl.Player do

  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()

    interact({game, Hangman.tally(game)})
    :ok
  end

  #@type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used
  #   @type tally :: %{
#    turns_left: integer,
#    game_state: state,
#    letters: list(String.t),
#    used: list(String.t),
#  }


  @spec interact(state) :: :ok
  #defp interact(state) do
  #  # Take current state
  #  # give feedback
  #  # display current word
  #  # get next guess
  #  # make a move
  #  # call ourselves again
  #  :ok
  #end
  defp interact({_game, tally=%{game_state: state}})
  when state in [:won, :lost] do
    give_feedback(tally)
    put_word(tally)
    :ok
  end

  defp interact({game, tally}) do
    give_feedback(tally)
    put_word(tally)
  end

  @spec give_feedback(tally) :: :ok
  defp give_feedback(tally=%{game_state: :initializing}) do
    IO.puts("Ready to play?")
    IO.puts("Turns left: #{tally.turns_left}")
  end

  defp give_feedback(tally=%{game_state: :good_guess}) do
    IO.puts("Good guess!")
    IO.puts("Turns left: #{tally.turns_left}")
    put_guesses(tally)
  end

  defp give_feedback(tally=%{game_state: :bad_guess}) do
    IO.puts("Bad guess!")
    IO.puts("Turns left: #{tally.turns_left}")
    put_guesses(tally)
  end

  defp give_feedback(tally=%{game_state: :already_used}) do
    IO.puts("Letter already used!")
    put_guesses(tally)
  end

  defp give_feedback(tally=%{game_state: :won}) do
    IO.puts("You won!")
    IO.puts("Turns left #{tally.turns_left}")
  end

  defp give_feedback(tally=%{game_state: :lost}) do
    IO.puts("You lost :(")
    IO.puts("Turns left: #{tally.turns_left}")
    put_guesses(tally)
  end


  @spec put_word(tally) :: :ok
  defp put_word(%{letters: l}) do
    IO.puts(Enum.reduce(l, "", fn elem, acc -> acc <> elem <> " " end))
  end

  @spec put_guesses(tally) :: :ok
  defp put_guesses(%{used: l}) do
    IO.puts("Letters used: #{Enum.reduce(l, "", fn elem, acc -> acc <> elem <> " " end)}")
  end
end
