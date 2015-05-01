# Sequel::RecordLoader

Simple gem that loads record definitions from a JSON or YAML file and synchronizes them to the database.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sequel-record_loader', git: 'git@git.noxqsapp.nl:gems/sequel-record_loader.git'
```

And then execute:

    $ bundle

## Usage

You need a file describing your records:

```yaml
User:
  - where:
      username: test
      email: test@example.com
    attributes:
      firstname: bob
      lastname: bobson
      dob: 18-10-1985
    associations:
      address:
        street: 5th avenue
        number: 102
      siblings:
        - firstname: babette
          lastname: bobson
        - firstname: bobby
          lastname: bobson
  - where: 3
    attributes:
      firstname: john
      lastname: johnson
      dob: 12-11-1993
```

Then simply call load:

```ruby
Sequel::RecordLoader.load 'your_file.yaml'

# db/records.json and db/records.yaml are automatically tried if no argument is given.
Sequel::RecordLoader.load
```

Sequel Record Loader will try finding each record with the supplied where statement.
This can be either an ID or a hash of attributes.

If the record is found then it is updated with the attributes.

If not then the record is created with the attributes and, if the where statement was a hash, the where statement.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sequel-record_loader/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
