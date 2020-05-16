# frozen_string_literal: true

class MathExpression::Parser
  def initialize(expression)
    @expression = expression
  end

  def to_tokens
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
        tokens << { type: :operator, value: character }
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

  def to_postfix
    output_queue = []
    operator_stack = []

    to_tokens.each do |token|
      type, value = token[:type], token[:value]

      case type
      when :number
        output_queue << value
      when :operator
        loop do
          break if operator_stack.empty?
          break if left_parenthesis?(operator_stack.last)
          operator_on_stack_precedence = operator_precedence(operator_stack.last)
          current_operator_precedence = operator_precedence(value)
          break if operator_on_stack_precedence <= current_operator_precedence

          output_queue << operator_stack.pop
        end
        operator_stack.push(value)
      when :parenthesis
        if left_parenthesis?(value)
          operator_stack.push(value)
        else
          while !left_parenthesis?(operator_stack.last)
            output_queue << operator_stack.pop
          end
          if left_parenthesis?(operator_stack.last)
            operator_stack.pop
          end
        end
      end
    end
    (output_queue + operator_stack.reverse)
  end

  def evaluate
    stack = []
    to_postfix.each do |token|
      result = case token
      when '+'
        stack.pop + stack.pop
      when '-'
        first, second = stack.pop, stack.pop
        second - first
      when '*'
        stack.pop * stack.pop
      when '/'
        first, second = stack.pop, stack.pop
        second / first
      else
        token.to_f
      end
      stack.push(result)
    end
    stack.pop
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
