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

  test "(Print Hello)" do
    result = Lexer.tokenize("(Print Hello)")
    assert_lists_equal(result, [:open_bracket, :Print, :Hello, :close_bracket, :eof])
  end

  test "(Print \"Hello World\")" do
    result = Lexer.tokenize("(Print \"Hello World\")")
    assert_lists_equal(result, [:open_bracket, :Print, :"Hello World", :close_bracket, :eof])
  end

  test "(Print \"Hello ( ) World\")" do
    result = Lexer.tokenize("(Print \"Hello ( ) World\")")
    assert_lists_equal(result, [:open_bracket, :Print, :"Hello ( ) World", :close_bracket, :eof])
  end

  test "(Print \"Hello (\n) World\")" do
    result =
      Lexer.tokenize("""
      (Print \"Hello (
      ) World\")
      """)

    assert_lists_equal(result, [:open_bracket, :Print, :"Hello (\n) World", :close_bracket, :eof])
  end
end
