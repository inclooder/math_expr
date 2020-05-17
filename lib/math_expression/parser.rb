# frozen_string_literal: true

require_relative './postfix_evaluator'
require_relative './tokenizer'

class MathExpression::Parser
  def initialize(expression)
    @expression = expression
  end

  def to_tokens
    MathExpression::Tokenizer.new(expression).call
  end

  def to_postfix
    output_queue = []
    operator_stack = []

    tokens = to_tokens

    tokens.each do |token|
      type, value = token[:type], token[:value]

      case type
      when :number
        output_queue << value
      when :operator
        loop do
          break if operator_stack.empty?
          break if operator_stack.last && operator_stack.last[:value] == '('
          break if operator_stack.last && operator_stack.last[:precedence] <= token[:precedence]

          output_queue << operator_stack.pop[:value]
        end
        operator_stack.push(token)
      when :parenthesis
        if token[:value] == '('
          operator_stack.push(token)
        else
          while operator_stack.last && operator_stack.last[:value] != '('
            output_queue << operator_stack.pop[:value]
          end
          if operator_stack.last && operator_stack.last[:value] == '('
            operator_stack.pop
          end
        end
      end
    end

    (output_queue + operator_stack.reverse.map { |x| x[:value] })
  end

  def evaluate
    MathExpression::PostfixEvaluator.new(to_postfix).call
  end

  private

  attr_reader :expression
end
