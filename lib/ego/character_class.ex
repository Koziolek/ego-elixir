defmodule Ego.CharacterClass do
  @moduledoc false

  defmacro is_new_line?(h) do
    quote do
      unquote([h]) === '\n'
    end
  end

  def is_digit?([h|_]) when h >= 48 and h <= 57, do: true
  def is_digit?(h) when h >= 48 and h <= 57, do: true
  def is_digit?(_), do: false

  def is_sign?([h|_]) when h == 43 or h == 45, do: true
  def is_sign?(h) when h == 43 or h == 45, do: true
  def is_sign?(_), do: false

  def is_dot?([h|_]) when h == 46, do: true
  def is_dot?(h) when h == 46, do: true
  def is_dot?(_), do: false

  def is_open_bracket([h|_]) when h == 40, do: true
  def is_open_bracket(h) when h == 40, do: true
  def is_open_bracket(_), do: false

  def is_close_bracket([h|_]) when h == 41, do: true
  def is_close_bracket(h) when h == 41, do: true
  def is_close_bracket(_), do: false

  def is_space([h|_]) when h == 32, do: true
  def is_space(h) when h == 32, do: true
  def is_space(_), do: false

  def is_semicolon([h|_]) when h == 59, do: true
  def is_semicolon(h) when h == 59, do: true
  def is_semicolon(_), do: false

  def is_double_quote([h|_]) when h == 34, do: true
  def is_double_quote(h) when h == 34, do: true
  def is_double_quote(_), do: false
  
end
