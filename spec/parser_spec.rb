require_relative '../lib/expression_parser'

describe ExpressionParser do
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

  context 'for long expression' do
    let(:expression) { '1 + 4 + 5 - 6 * 2' }

    describe '#to_postfix' do
      subject { parser.to_postfix }

      it 'returns postfix notation' do
         expect(subject).to eq([1, 4, '+', 5, '+', 6, 2, '*', '-'])
      end
    end

    describe '#evaluate' do
      subject { parser.evaluate }

      it 'returns postfix notation' do
        expect(subject).to eq(-2)
      end
    end
  end
end

