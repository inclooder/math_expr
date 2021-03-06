# MathExpr

Parses a mathematical expression from infix notation into reverse polish notation and produces a result.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'math_expr'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install math_expr

## Usage

```ruby
require 'math_expression/parser'

parser = MathExpression::Parser.new('4 + 5')

parser.to_tokens # => [{:type=>:number, :value=>4}, {:type=>:operator, :value=>"+"}, {:type=>:number, :value=>5}]

parser.to_postfix # => [4, 5, "+"]

parser.evaluate # => 9
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake respec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/inclooder/math_expression.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
