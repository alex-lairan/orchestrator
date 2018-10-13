# Orchestrator

Orchestrator provide a way to organize services with the Service Layer Pattern and the Composer Pattern.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'orchestrator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install orchestrator

## Usage

This gem have 2 mains parts:
- Composer (permit to organise multiples Layers (and services in general)
- Layer (handle simple business logic)

### Composer

Manage multiples layers and services.

#### DSL

- `compose`
- `step`
- `valid`
- `proc`

### Layer

Simple implement `perform` method who get an hash as input, and send a monad as output.

### Exemple

```ruby
class Users::Service::EmailUnicity
  include Orchestrator.layer

  attribute :email

  def perform(input)
    if User.where(email: email).exists?
      Failure(input.merge(errors: ['Email already used']))
    else
      Success(input)
    end
  end
end

class Users::Service::Persistance
  include Orchestrator.layer

  attribute :email
  attribute :password

  def perform(input)
    user = User.new(email: email, password: password)
    
    if user.save
      Success(input.merge(user: user))
    else
      Failure(input.merge(errors: user.errors))
    end
  end
end

Users::Validators::Base = Dry::Validation.Schema do
  require(:email).filled { str & format(EMAIL_REGEX) }
  require(:password).filled { min_size(8) }
end

class Users::Create
  include Orchestrator.composer

  valid :validate, klass: Users::Validators::Base
  compose :unicity, klass: Users::Service::EmailUnicity
  compose :persist, klass: Users::Service::Persistance
end

composer = User::Create.new
composer.call(email: 'fail@email', password: 'short')
# => Dry::Monads::Result::Failure(email: 'fail@email', password: 'short', errors: { email: [...], password: [...]})
composer.call(email: 'email@example.com', password: 'compliant password')
# => Dry::Monads::Result::Success(email: 'email@example.com', password: 'compliant password', user: <#User ...>)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alex-lairan/orchestrator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Orchestrator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/alex-lairan/orchestrator/blob/master/CODE_OF_CONDUCT.md).
