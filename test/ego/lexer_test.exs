defmodule Ego.LexerTest do
  use ExUnit.Case
  import Assertions
  alias Ego.Lexer

  @moduletag :capture_log

  doctest Lexer

  test "()" do
    result = Lexer.tokenize("()")
    assert_lists_equal(result, [:open_bracket, :close_bracket, :eof])
  end

  test "( )" do
    result = Lexer.tokenize("( )")
    assert_lists_equal(result, [:open_bracket, :close_bracket, :eof])
  end

end
