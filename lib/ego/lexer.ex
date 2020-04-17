defmodule Ego.Lexer do
  def tokenize(program) when is_binary(program) do
    program
    |> String.split("")
    |> token
  end

  defp token(charlist, accumulator \\ [])
  defp token([], accumulator), do: accumulator ++ [:eof]

  defp token(charlist, accumulator) do
    [h | t] = charlist

    case h do
      "(" -> token(t, accumulator ++ [:open_bracket])
      ")" -> token(t, accumulator ++ [:close_bracket])
      " " -> token(t, accumulator ++ [:close_bracket])
      _ -> token(t, accumulator)
    end
  end

end
