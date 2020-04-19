defmodule Ego.Token do
  @enforce_keys [:kind, :value]
  defstruct [:kind, :value]

  def open_bracket(), do: %Ego.Token{kind: :open_bracket, value: '('}
  def close_bracket(), do: %Ego.Token{kind: :close_bracket, value: ')'}
  def eof(), do: %Ego.Token{kind: :eof, value: ''}
  def atom([]), do: []
  def atom(value), do: %Ego.Token{kind: :atom, value: value}
  def string([]), do: []
  def string(value), do: %Ego.Token{kind: :string, value: value}
end
