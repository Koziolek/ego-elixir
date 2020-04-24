defmodule Ego.CharacterClass do
  @moduledoc false

  defmacro is_new_line?(h) do
    quote do
      unquote([h]) === '\n'
    end
  end

  defmacro is_digit?(h) do
    quote do
      unquote(h) >= 48 and unquote(h) <= 57
    end
  end

  defmacro is_sign?(h) do
    quote do
      unquote([h]) === '+' or unquote([h]) === '-' or unquote(h) === '+' or unquote(h) === '-'
    end
  end

  defmacro is_dot?(h) do
    quote do
      unquote([h]) === '.'
    end
  end

  defmacro is_open_bracket?(h) do
    quote do
      unquote([h]) === '('
    end
  end

  defmacro is_close_bracket?(h) do
    quote do
      unquote([h]) === ')'
    end
  end

  defmacro is_space?(h)  do
    quote do
      unquote([h]) === ' '
    end
    end

  defmacro is_semicolon?(h)  do
    quote do
      unquote([h]) === ';'
    end
  end

  defmacro is_double_quote?(h) do
    quote do
      unquote([h]) === '"'
    end
  end


end
