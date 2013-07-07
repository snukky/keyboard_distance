# KeyboardDistance

Simple algorithm for measuring of distance-on-keyboard between two strings
for various keyboard layouts.

A diagonal distance between two keys equals the longer distance in a straight 
line to the appropriate row/column, e.g.:

    require 'keyboard_distance'
    keyboard = KeyboardDistance.new

    keyboard.character_distance('q', 'w') # => 1.0
    keyboard.character_distance('q', 's') # => 1.0
    keyboard.character_distance('q', 'd') # => 2.0

The similarity of the two strings is:

    1.0 - (D / (L * M))

Where `D` is the distance between the two strings, L is the length of the
longer string, and M is the maximum key distance for given layout.

## Installation

Add this line to your application's Gemfile:

    gem 'keyboard_distance'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install keyboard_distance

## Usage

Require the gem:

    require 'keyboard_distance'

Basic usage:

    keyboard = KeyboardDistance.new
    keyboard.distance("foo", "boo")   # => 1.0
    keyboard.similarity("foo", "boo") # => 0.9770114942528736

    keyboard.distance("foo", "Boo")   # => 2.0
    keyboard.similarity("foo", "Boo") # => 0.9540229885057472

Extra parameters:

    keyboard = KeyboardDistance.new(:layout => :qwerty,
                                    :national_keys => :polish,
                                    :alt_distance => 0.5)

    keyboard.distance("między", "miedzy") # => 0.5
