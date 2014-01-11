# Pocketbeuter
[![Gem Version](https://badge.fury.io/rb/pocketbeuter.png)](http://badge.fury.io/rb/pocketbeuter) [![Build Status](https://travis-ci.org/pietrushnic/pocketbeuter.png?branch=master)](https://travis-ci.org/pietrushnic/pocketbeuter)

Pocketbeuter is a command line interface to [Pocket](http://getpocket.com) web application.

## Installation

Add this line to your application's Gemfile:

    gem 'pocketbeuter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pocketbeuter

## Usage

### Createapp

    pocketbeuter createapp

`createapp` subcommand guides through Pocket Application creating process. It asks about:
 - account name - this is only for configuration reference and don't have to be Pocket username - by default it sets current user
 - consumer key - you can find it after creating Pocket Application
 - redirect uri - it doesn't matter for pocketbeuter - by default I set auth.md of this project

### Authorize

    pocketbeuter authorize

After creating Pocket Application you can authorize to get access token. `authorize` subcommand
use Launchy to open browser id it doesn't work in you environment (i.e. you're over ssh) then
please copy displayed url and paste it browser.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
