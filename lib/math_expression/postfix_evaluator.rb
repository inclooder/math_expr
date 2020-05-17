# frozen_string_literal: true

class MathExpression::PostfixEvaluator
  def initialize(postfix)
    @postfix = postfix
    @stack = []
  end

  def call
    stack.clear
    postfix.each do |token|
      result = process_token(token)
      stack.push(result)
    end
    stack.pop
  end

  private

  attr_reader :stack, :postfix

  def process_token(token)
    case token
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
  end
end
