defmodule Ego.Lexer do
  def tokenize(program) when is_binary(program) do
    program
    |> String.to_charlist()
    |> token
  end

  defp token(charlist, accumulator \\ [])
  defp token([], accumulator), do: accumulator ++ [:eof]

  defp token(charlist, accumulator) do
    [h | t] = charlist

    case h do
      40 -> token(t, accumulator ++ [:open_bracket])
      41 -> token(t, accumulator ++ [:close_bracket])
    end
  end

end
