defmodule TextClient.Impl.Player do

  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()

    interact({game, Hangman.tally(game)})
  end

  @spec interact(state) :: :ok
  defp interact({_game, %{game_state: :won}}) do
    IO.puts("Congratulations, you won!")
  end

  defp interact({_game, tally=%{game_state: :lost}}) do
    IO.puts("Sorry... you lost, the word was #{Enum.join(tally.letters)}")
  end

  defp interact({game, tally}) do
    give_feedback(tally)
    put_word(tally)
    {game, tally} = Hangman.make_move(game, get_next_guess())
    interact({game, tally})
  end

  @spec give_feedback(tally) :: :ok
  defp give_feedback(tally=%{game_state: :initializing}) do
    IO.puts("Ready to play?")
    IO.puts("Try to guess a #{length(tally.letters)} lettered word")
  end

  defp give_feedback(%{game_state: :good_guess}) do
    IO.puts("Good guess!")
  end

  defp give_feedback(%{game_state: :bad_guess}) do
    IO.puts("Bad guess!")
  end

  defp give_feedback(%{game_state: :already_used}) do
    IO.puts("Letter already used!")
  end

  defp give_feedback(%{game_state: :invalid_guess}) do
    IO.puts("Please input a single lowercase letter!")
  end


  @spec put_word(tally) :: :ok
  defp put_word(tally=%{letters: l}) do
    IO.puts("Turns left: #{tally.turns_left}")
    IO.puts("Letters used: #{Enum.reduce(tally.used, "", fn elem, acc -> acc <> elem <> " " end)}")
    IO.puts("Word so far: #{Enum.join(l, " ")}")
  end

  @spec get_next_guess() :: String.t
  defp get_next_guess() do
    IO.gets("Next guess: ")
    |> String.trim("\n")
    |> String.downcase()
  end

end
