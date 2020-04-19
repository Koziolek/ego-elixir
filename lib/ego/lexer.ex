defmodule Ego.Lexer do
  import Ego.Token

  def tokenize(program) when is_binary(program) do
    program
    |> String.to_charlist()
    |> tokens
    |> Enum.reverse()
    |> List.flatten()
  end

  defp tokens(charlist, accumulator \\ [], buffer \\ [], mode \\ :common)
  defp tokens([], accumulator, _, _), do: [eof()] ++ accumulator

  defp tokens([h | t], accumulator, buffer, :common) do
    cond do
      '(' === [h] -> tokens(t, [open_bracket()] ++ [atom(read_buffer(buffer))] ++ accumulator, [])
      ')' === [h] -> tokens(t, [close_bracket()] ++ [atom(read_buffer(buffer))] ++ accumulator, [])
      ' ' === [h] -> tokens(t, [atom(read_buffer(buffer))] ++ accumulator, [])
      '"' === [h] -> tokens(t, [atom(read_buffer(buffer))] ++ accumulator, [], :text)
      true -> tokens(t, accumulator, [h] ++ buffer)
    end
  end

  defp tokens([h | t], accumulator, buffer, :text) do
    cond do
      '"' === [h] -> tokens(t, [string(read_buffer(buffer))] ++ accumulator, [], :common)
      true -> tokens(t, accumulator, [h] ++ buffer, :text)
    end
  end

  defp read_buffer([]), do: []

  defp read_buffer(buffer) do
    buffer |> Enum.reverse()
  end
end
