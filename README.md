# Capitoshka [![Build Status](https://secure.travis-ci.org/yevgenko/capitoshka.png?branch=master)](https://travis-ci.org/yevgenko/capitoshka)

Simple web API in front of capistrano that translates requests into cap commands.


## Installation

1. Get dependencies with `bundle install`
2. Copy capistrano recipes or entire project into subfolder under `.projects`
    directory, e.g.: `.projects/foo-bar`

NOTE: the `.projects` directory can be anywhere on the same server, but
defaults to the current path, see [Usage](#usage) section.


## Usage

    bundle exec ruby app.rb

By default capistrano recipes must be located in `.projects` directory, but you
can change that with `CAP_PROJECTS_PATH` environment variable, e.g.:

    CAP_PROJECTS_PATH="/home/my/.projects" bundle exec ruby app.rb


## API

* [List projects](#list-projects)
* [Execute cap command](#execute-cap-command)

### List projects

    GET /projects

#### Response

    {
        "projects": [
            {
                "name": "a"
            },
            {
                "name": "cap-foobar"
            },
            {
                "name": "b"
            }
        ]
    }

### Execute cap command

    POST /projects/:name/cap

#### Input

* `name`, required string - The name of project/directory where specific recipes persists;
* `args`, required array - The command-line parameters to pass to `cap` command.

Example:

    {
        "args":["deploy:check"]
    }

#### Response

    {
        "ok"
    }


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
