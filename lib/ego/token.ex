defmodule Ego.Token do
  @enforce_keys [:kind, :value]
  defstruct [:kind, :value]
end
