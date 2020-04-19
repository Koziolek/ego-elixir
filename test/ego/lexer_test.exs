defmodule Ego.LexerTest do
  use ExUnit.Case
  import Assertions
  alias Ego.Lexer
  alias Ego.Token

  @moduletag :capture_log

  doctest Lexer

  test "()" do
    result = Lexer.tokenize("()")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "( )" do
    result = Lexer.tokenize("( )")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(Print Hello)" do
    result = Lexer.tokenize("(Print Hello)")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: 'Print'},
      %Token{kind: :atom, value: 'Hello'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(Print \"Hello World\")" do
    result = Lexer.tokenize("(Print \"Hello World\")")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: 'Print'},
      %Token{kind: :string, value: 'Hello World'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(Print \"Hello ( ) World\")" do
    result = Lexer.tokenize("(Print \"Hello ( ) World\")")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: 'Print'},
      %Token{kind: :string, value: 'Hello ( ) World'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(Print \"Hello (\n) World\")" do
    result =
      Lexer.tokenize("""
      (Print \"Hello (
      ) World\")
      """)

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: 'Print'},
      %Token{kind: :string, value: 'Hello (\n) World'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(\u0061\u0301)" do
    result = Lexer.tokenize("(\u0061\u0301)")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: '\u0061\u0301'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end
end
