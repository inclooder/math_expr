# frozen_string_literal: true

class MathExpression::Tokenizer
  def initialize(expression)
    @expression = expression
  end

  def call
    tokens = []
    reading_number = []

    form_number = lambda do
      return if reading_number.empty?
      num = reading_number.join.to_f
      tokens << { type: :number, value: num }
      reading_number = []
    end

    printable_chars = expression.chars.reject { |c| c == ' ' }

    printable_chars.each do |character|
      if operator?(character)
        form_number.call
        tokens << {
          type: :operator,
          value: character,
          precedence: operator_precedence(character)
        }
      elsif parenthesis?(character)
        form_number.call
        tokens << { type: :parenthesis, value: character }
      else
        reading_number << character
      end
    end
    form_number.call
    tokens
  end

  private

  OPERATORS = {
    '+' => 2,
    '-' => 2,
    '*' => 3,
    '/' => 3,
  }.freeze

  def operator?(token)
    OPERATORS.keys.include?(token)
  end

  def operator_precedence(operator)
    OPERATORS.fetch(operator)
  end

  def parenthesis?(token)
    left_parenthesis?(token) || right_parenthesis?(token)
  end

  def left_parenthesis?(token)
    token == '('
  end

  def right_parenthesis?(token)
    token == ')'
  end

  attr_reader :expression
end
