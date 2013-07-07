# encoding: utf-8

require 'spec_helper'

describe KeyboardDistance do
  before :all do
    @keyboard = KeyboardDistance.new(:layout => :qwerty,
                                     :national_keys => :polish,
                                     :shift_distance => 1,
                                     :alt_distance => 0.5,
                                     :space_distance => 2,
                                     :unknown_char_distance => 1)
  end

  describe "character_distance" do
    it "should return zero for equal characters" do
      @keyboard.character_distance('a', 'a').should eql 0.0
      @keyboard.character_distance('A', 'A').should eql 0.0
      @keyboard.character_distance('ą', 'ą').should eql 0.0
    end

    it "should measure distances in a straight line" do
      @keyboard.character_distance('a', 's').should eql 1.0
      @keyboard.character_distance('a', 'l').should eql 8.0
      @keyboard.character_distance('a', 'z').should eql 1.0
      @keyboard.character_distance('a', '1').should eql 2.0
    end

    it "should measure diagonally distances" do
      @keyboard.character_distance('s', 'q').should eql 1.0
      @keyboard.character_distance('s', 'e').should eql 1.0
      @keyboard.character_distance('s', 'c').should eql 1.0
      @keyboard.character_distance('s', 'z').should eql 1.0

      @keyboard.character_distance('q', 'd').should eql 2.0
      @keyboard.character_distance('q', '3').should eql 2.0

      @keyboard.character_distance('q', 'p').should eql 9.0
    end

    it "should increase distance when shift is pressed" do
      @keyboard.character_distance('a', 'z').should be <
        @keyboard.character_distance('A', 'z')
    end

    it "should return the same distance when shift is pressed twice" do
      @keyboard.character_distance('a', 'y').should eql \
        @keyboard.character_distance('A', 'Y')
    end

    it "should increase distance when alt is pressed" do
      @keyboard.character_distance('a', 'z').should be <
        @keyboard.character_distance('ą', 'z')
    end
    
    it "should return the same distance when alt is pressed twice" do
      @keyboard.character_distance('a', 'z').should eql \
        @keyboard.character_distance('ą', 'ż')
    end

    it "should work with a space character" do
      expect{ @keyboard.character_distance('a', ' ') }.not_to raise_error
    end

    it "should work with unknown character" do
      expect{ @keyboard.character_distance('a', '¶') }.not_to raise_error
    end
  end

  describe "distance" do
    it "should return zero for equals words" do
      @keyboard.distance("foo", "foo").should eql 0.0
      @keyboard.distance("FOO", "FOO").should eql 0.0
    end

    it "should measure distance as the sum of character distances" do
      word_1 = "foo"
      word_2 = "bar"

      sum_of_char_distances = 0.0
      word_1.each_char.with_index do |char, idx|
        sum_of_char_distances += @keyboard.character_distance(char, word_2[idx])
      end

      @keyboard.distance(word_1, word_2).should eql sum_of_char_distances
    end

    it "should measure simple distances" do
      @keyboard.distance("asd", "sdf").should eql 3.0
      @keyboard.distance("1qaz", "2wsx").should eql 4.0
      @keyboard.distance("qsc", "wdv").should eql 3.0

      @keyboard.distance("foo", "Foo").should eql 1.0
      @keyboard.distance("laka", "łąka").should eql 1.0
    end

    it "should work with different length strings" do
      expect{ @keyboard.distance("foo", "bar baz") }.not_to raise_error
    end
  end

  describe "similarity" do
    it "should give 1 for the same strings" do
      @keyboard.similarity("foo", "foo").should eql 1.0
    end

    it "should work for simple strings" do
      expected_value = (1 - 1 / (3 * @keyboard.max_distance))
      @keyboard.similarity("foo", "boo").should eql expected_value
    end

    it "should decrease similarity for longer string" do
      @keyboard.similarity("foo", "boo").should be <
        @keyboard.similarity("foooooo", "boooooo")
    end
  end

end
