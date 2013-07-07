# encoding: utf-8

require 'spec_helper'

describe KeyboardLayout do
  before :all do
    @layout = KeyboardLayout::LAYOUTS.keys.first
  end

  describe "build_shifted_keys_map" do
    it "should return a Hash object" do
      KeyboardLayout.build_shifted_keys_map(@layout).should be_kind_of Hash
    end

    it "should have capital characters as keys" do
      KeyboardLayout.build_shifted_keys_map(@layout).keys
        .all?{ |big| big.upcase == big }.should be_true
    end

    it "should have small characters as keys" do
      KeyboardLayout.build_shifted_keys_map(@layout).values
        .all?{ |small| small.downcase == small }.should be_true
    end
  end

  describe "layout_defined?" do
    it "should raise error when access to undefined layout" do
      expect{ KeyboardLayout.print_layout(:unexisted_layout) }.to raise_error
    end
  end
end
