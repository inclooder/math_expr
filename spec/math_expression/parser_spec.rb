require 'math_expression/parser'

describe MathExpression::Parser do
  let(:expression) { 'a + b * c' }
  let(:parser) { described_class.new(expression) }

  context 'for simple expresssion' do
    let(:expression) { '4 + 5' }

    describe '#to_tokens' do
      subject { parser.to_tokens }

      it 'returns the correct tokens' do
        expect(subject).to eq([
          { type: :number, value: 4 },
          { type: :operator, value: '+' },
          { type: :number, value: 5 },
        ])
      end
    end

    describe '#to_postfix' do
      subject { parser.to_postfix }

      it 'returns postfix notation' do
        expect(subject).to eq([4, 5, '+'])
      end
    end

    describe '#evaluate' do
      subject { parser.evaluate }

      it 'returns the correct result' do
        expect(subject).to eq(9)
      end
    end
  end

  context 'for expression with different precedence operators' do
    let(:expression) { '1 + 4 + 5 - 6 * 2' }

    describe '#to_postfix' do
      subject { parser.to_postfix }

      it 'returns postfix notation' do
        expect(subject).to eq([1.0, 4.0, 5.0, 6.0, 2.0, '*', '-', '+', '+'])
      end
    end

    describe '#evaluate' do
      subject { parser.evaluate }

      it 'returns postfix notation' do
        expect(subject).to eq(-2)
      end
    end
  end

  describe '#evaluate' do
    it 'handles expressions with one operator' do
      {
        '1 + 1' => 2,
        '2 + 3' => 5,
        '123 + 999' => 1122,
        '54-1' => 53,
        '23-100' => -77,
        '6/  2' => 3,
        '3 / 2' => 1.5
      }.each do |input, result|
        expect(described_class.new(input).evaluate).to eq(result)
      end
    end

    it 'handles expressions with many operators' do
      {
        '1 + 1 + 2' => 4,
        '2 + 3 - 23' => -18,
        '123 + 999 / 111' => 132,
        '2 + 1 + 33 / 3' => 14,
      }.each do |input, result|
        expect(described_class.new(input).evaluate).to eq(result)
      end
    end

    it 'handles expressions with parenthesis' do
      {
        '(2 + 2) * 2' => 8,
        '16 / (2 + 2) * 2' => 2,
        '(1 + (2 + 2)) * 2' => 10,
      }.each do |input, result|
        expect(described_class.new(input).evaluate).to eq(result)
      end
    end
  end
end

