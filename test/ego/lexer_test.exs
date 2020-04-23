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

  test "Print" do
    result = Lexer.tokenize("Print")

    assert_lists_equal(result, [
      %Token{kind: :atom, value: 'Print'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "; komentarz" do
    result = Lexer.tokenize("; komentarz")

    assert_lists_equal(result, [
      %Token{kind: :eof, value: ''}
    ])
  end

  test "1029" do
    result = Lexer.tokenize("1029")

    assert_lists_equal(result, [
      %Token{kind: :number, value: '1029'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "+1029" do
    result = Lexer.tokenize("+1029")

    assert_lists_equal(result, [
      %Token{kind: :number, value: '1029'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "-1029" do
    result = Lexer.tokenize("-1029")

    assert_lists_equal(result, [
      %Token{kind: :number, value: '-1029'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(1029)" do
    result = Lexer.tokenize("(1029)")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :number, value: '1029'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(Print 1029)" do
    result = Lexer.tokenize("(Print 1029)")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: 'Print'},
      %Token{kind: :number, value: '1029'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(1029test)" do
    result = Lexer.tokenize("(1029test)")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: '1029test'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(10+29)" do
    result = Lexer.tokenize("(10+29)")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: '10+29'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(1029test1029)" do
    result = Lexer.tokenize("(1029test1029)")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: '1029test1029'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "1.1" do
    result = Lexer.tokenize("1.1")

    assert_lists_equal(result, [
      %Token{kind: :number, value: '1.1'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "+1.1" do
    result = Lexer.tokenize("+1.1")

    assert_lists_equal(result, [
      %Token{kind: :number, value: '1.1'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "-1.1" do
    result = Lexer.tokenize("-1.1")

    assert_lists_equal(result, [
      %Token{kind: :number, value: '-1.1'},
      %Token{kind: :eof, value: ''}
    ])
  end

  test "(print \"4+5\" (+ 4 5))" do
    result = Lexer.tokenize("(print \"4+5\" (+ 4 5))")

    assert_lists_equal(result, [
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: 'print'},
      %Token{kind: :string, value: '4+5'},
      %Token{kind: :open_bracket, value: '('},
      %Token{kind: :atom, value: '+'},
      %Token{kind: :number, value: '4'},
      %Token{kind: :number, value: '5'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :close_bracket, value: ')'},
      %Token{kind: :eof, value: ''}
    ])
  end
end
