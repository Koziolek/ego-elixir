defmodule Ego.Lexer do
  import Ego.Token
  import Ego.CharacterClass

  def tokenize(program) when is_binary(program) do
    program
    |> String.to_charlist()
    |> tokens
    |> Enum.reverse()
    |> List.flatten()
  end

  defp tokens(charlist, accumulator \\ [], buffer \\ [], mode \\ :common)
  defp tokens([], accumulator, buffer, :number), do: [eof()] ++ [number(read_buffer(buffer))] ++ accumulator
  defp tokens([], accumulator, buffer, _), do: [eof()] ++ [atom(read_buffer(buffer))] ++ accumulator

  defp tokens([h | t], accumulator, buffer, :common) do
    cond do
      is_open_bracket?(h) -> tokens(t, [open_bracket()] ++ [atom(read_buffer(buffer))] ++ accumulator, [])
      is_close_bracket?(h) -> tokens(t, [close_bracket()] ++ [atom(read_buffer(buffer))] ++ accumulator, [])
      is_space?(h) -> tokens(t, [atom(read_buffer(buffer))] ++ accumulator, [])
      is_double_quote?(h) -> tokens(t, [atom(read_buffer(buffer))] ++ accumulator, [], :text)
      is_semicolon?(h) -> tokens(t, [atom(read_buffer(buffer))] ++ accumulator, [], :comment)
      is_digit?(h) || is_sign?(h) -> tokens(t, accumulator, [h] ++ buffer, :number)
      true -> tokens(t, accumulator, [h] ++ buffer)
    end
  end

  defp tokens([h | t], accumulator, buffer, :text) do
    cond do
      is_double_quote?(h) -> tokens(t, [string(read_buffer(buffer))] ++ accumulator, [], :common)
      true -> tokens(t, accumulator, [h] ++ buffer, :text)
    end
  end

  defp tokens([h | t], accumulator, _, :comment) when is_new_line?(h), do: tokens(t, accumulator, [])
  defp tokens([_ | t], accumulator, _, :comment), do: tokens(t, accumulator, [], :comment)

  defp tokens([h | t] = program, accumulator, buffer, :number) do
    cond do
      !has_only_digits?(buffer, true, false) -> tokens(t, accumulator, [h] ++ buffer)
      is_digit?(h) -> tokens(t, accumulator, [h] ++ buffer, :number)
      is_dot?(h) -> tokens(t, accumulator, [h] ++ buffer, :number)
      is_space?(h) && length(buffer) == 1 && is_sign?(buffer) -> tokens(program, accumulator, buffer)
      is_space?(h) || is_close_bracket?(h) -> tokens(program, [number(read_buffer(buffer))] ++ accumulator, [])
      true -> tokens(t, accumulator, [h] ++ buffer)
    end
  end

  defp has_only_digits?([], v, _), do: v
  defp has_only_digits?([h | _] = buffer, v, _) when length(buffer) == 1, do: (is_digit?(h) || is_sign?(h)) && v

  defp has_only_digits?([h | t], v, has_dot) do
    if has_dot do
      has_only_digits?(t, is_digit?(h) && v, has_dot)
    else
      has_only_digits?(t, (is_digit?(h) || is_dot?(h)) && v, is_dot?(h))
    end
  end

  defp read_buffer([]), do: []

  defp read_buffer(buffer) do
    buffer |> Enum.reverse()
  end
end
