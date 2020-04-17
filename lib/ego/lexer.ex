defmodule Ego.Lexer do
  def tokenize(program) when is_binary(program) do
    program
    |> String.split("", trim: true)
    |> token
  end

  defp token(charlist, accumulator \\ [], buffer \\ [], mode \\ :common)
  defp token([], accumulator, buffer, _), do: accumulator ++ [:eof]

  defp token(charlist, accumulator, buffer, :common) do
    [h | t] = charlist

    case h do
      "(" -> token(t, accumulator ++ read_buffer(buffer) ++ [:open_bracket], [])
      ")" -> token(t, accumulator ++ read_buffer(buffer) ++ [:close_bracket], [])
      " " -> token(t, accumulator ++ read_buffer(buffer), [])
      "\"" -> token(t, accumulator ++ read_buffer(buffer), [], :text)
      _ -> token(t, accumulator, buffer ++ [h])
    end
  end

  defp token(charlist, accumulator, buffer, :text) do
    [h | t] = charlist

    case h do
      "\"" -> token(t, accumulator ++ read_buffer(buffer), [], :common)
      _ -> token(t, accumulator, buffer ++ [h], :text)
    end
  end

  defp read_buffer([]), do: []

  defp read_buffer(buffer) do
    [buffer |> Enum.join("") |> String.to_atom()]
  end

end
