# Runtime Conf Tool

A middleware to change configuration parameters at runtime for Rails 5.

**NOTE**: this is an alpha version, this gem is not yet released on rubygems, major changes could happen.

## Installation and Usage

- Add this to your `Gemfile`:

`gem 'runtime_conf_tool', git: 'https://github.com/blocknotes/runtime_conf_tool.git'`

- Add to `config/environments/development.rb` (_path_ option is not mandatory, '/dev' is the default value):

`config.middleware.use RuntimeConfTool::Middleware, path: '/some_path'`

- Open the path (or the one set in the option): **/dev**

## Features

- Change log level
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
