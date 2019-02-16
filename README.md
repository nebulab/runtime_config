# Runtime Config for Rails [![Gem Version](https://badge.fury.io/rb/runtime_config.svg)](https://badge.fury.io/rb/runtime_config)

A middleware to change configuration parameters at runtime for Rails 5.

## Installation and Usage

- Add to `Gemfile`: `gem 'runtime_config'`
- Add to `config/environments/development.rb`: `config.middleware.use RuntimeConfig::Middleware`
- Optionally specify a path, ex. `config.middleware.use RuntimeConfig::Middleware, path: '/some_path'`
- Open the path (or the one set in the option): **/dev**

## Features

- Change log level
- Filter log lines using a RegExp
- Enable/disable catching errors
- Eneble/disable verbose query logs
- Toggle cache
- Clear cache
- Restart server

## Preview

![screenshot](screenshot.png)

## Do you like it? Star it!

If you use this component just star it. A developer is more motivated to improve a project when there is some interest.

## Contributors

- [Mattia Roccoberton](http://blocknot.es) - creator, maintainer

## License

[MIT](LICENSE.txt)
