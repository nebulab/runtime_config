# Runtime Conf Tool [![Gem Version](https://badge.fury.io/rb/runtime_conf_tool.svg)](https://badge.fury.io/rb/runtime_conf_tool)

A middleware to change configuration parameters at runtime for Rails 5.

## Installation and Usage

- Add this to your `Gemfile`:

`gem 'runtime_conf_tool', git: 'https://github.com/blocknotes/runtime_conf_tool.git'`

- Add to `config/environments/development.rb` (_path_ option is not mandatory, '/dev' is the default value):

`config.middleware.use RuntimeConfTool::Middleware, path: '/some_path'`

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
