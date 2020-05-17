require_relative 'lib/math_expression/version'

Gem::Specification.new do |spec|
  spec.name          = "math_expr"
  spec.version       = MathExpression::VERSION
  spec.authors       = ["Inclooder"]
  spec.email         = ["inclooder@gmail.com"]

  spec.summary       = %q{Mathematical expression parser and executor}
  spec.description   = %q{Mathematical expression parser and executor}
  spec.homepage      = "https://github.com/inclooder/math_expr"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/inclooder/math_expr"
  spec.metadata["changelog_uri"] = "https://github.com/inclooder/math_expr"

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    Dir.glob(['**/*', '**/.??*']).
      select { |e| File.file?(e) }.
      reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rspec', '~> 3.9.0'
end
