defmodule Ego.Lexer do

  alias Ego.Token

  def tokenize(program) when is_binary(program) do
    program
    |> String.to_charlist()
    |> tokens
    |> Enum.reverse()
  end

  defp tokens(charlist, accumulator \\ [], buffer \\ [], mode \\ :common)
  defp tokens([], accumulator, _, _), do: [%Token{kind: :eof, value: ''}] ++ accumulator

  defp tokens([h | t], accumulator, buffer, :common) do
    cond do
      '(' === [h] -> tokens(t, [%Token{kind: :open_bracket, value: '('}] ++ read_buffer(buffer, :atom) ++ accumulator, [])
      ')' === [h] -> tokens(t, [%Token{kind: :close_bracket, value: ')'}] ++ read_buffer(buffer, :atom) ++ accumulator, [])
      ' ' === [h] -> tokens(t, read_buffer(buffer, :atom) ++ accumulator, [])
      '"' === [h] -> tokens(t, read_buffer(buffer, :atom) ++ accumulator, [], :text)
      true -> tokens(t, accumulator, [h] ++ buffer)
    end
  end

  defp tokens([h | t], accumulator, buffer, :text) do
    cond do
      '"' === [h] -> tokens(t, read_buffer(buffer, :string) ++ accumulator, [], :common)
      true -> tokens(t, accumulator, [h] ++ buffer, :text)
    end
  end

  defp read_buffer([], _), do: []

  defp read_buffer(buffer, kind) do
    value = buffer |> Enum.reverse()
    [%Token{kind: kind, value: value}]
  end
end
