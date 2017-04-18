# Gladius

Gladius is a zero-setup tool for accessing JSONAPI Resources.

```ruby
agent = Gladius::Agent.new("http://jsonapi-example.com/posts")
post = agent.index[0]
print post
Posts: 0223c8ea-0c31-4901-b20e-99123b408e08
  author_id: 80013143-e3fe-435e-8d86-b3da896625fa
       name: Great Post
  post_type: blog
#<Gladius::Resource:0x007f83a98fefb0>=> nil

post.name = "Even Better"
updated_post = post.save!
print updated_post
Posts: 0223c8ea-0c31-4901-b20e-99123b408e08
  author_id: 80013143-e3fe-435e-8d86-b3da896625fa
       name: Even Better
  post_type: blog
#<Gladius::Resource:0x007f83a8bea6f8>=> nil
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gladius'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gladius

## Usage

First start up a `Gladius::Agent` with a root resource URI:

```ruby
agent = Gladius::Agent.new("https://jsonapi-example.org/users")
```

* `#index` returns `Resource`-wrapped resuls from `GET`.
* `#get(id)` makes a `GET` call to the member(id) path of the base.
* `#new(attributes)` creates a new `Resource`.

When you have a `Resource`:

* `#<attribute>`: Returns value of attribute
* `#<attribute>=`: Sets the value
* `#save!`: Create or Update the resource
* `#to_s`: Pretty print the resource

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Carl Thuringer/gladius. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [Apache-2.0 License](https://www.apache.org/licenses/LICENSE-2.0).

