class ExpressionParser
  def initialize(expression)
    @expression = expression
  end

  def to_tokens
    tokens = []
    reading_number = []

    form_number = lambda do
      return if reading_number.empty?
      num = reading_number.join.to_i
      tokens << { type: :number, value: num }
      reading_number = []
    end

    expression.chars.each do |character|
      if operator?(character)
        form_number.call
        tokens << { type: :operator, value: character}
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
      case token[:type]
      when :number
        output_queue << token[:value]
      when :operator
        loop do
          break if operator_stack.empty?
          operator_on_stack_precedence = operator_precedence(operator_stack.last)
          current_operator_precedence = operator_precedence(token[:value])
          break if operator_on_stack_precedence < current_operator_precedence

          output_queue << operator_stack.pop
        end
        operator_stack.push(token[:value])
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
        stack.pop / stack.pop
      else
        token.to_i
      end
      stack.push(result)
    end
    stack.pop
  end

  private

  OPERATORS = %w(+ - * /).freeze

  def operator?(token)
    OPERATORS.include?(token)
  end

  def operator_precedence(operator)
    {
      '+' => 2,
      '-' => 2,
      '*' => 3,
      '/' => 3,
    }.fetch(operator)
  end

  attr_reader :expression
end
