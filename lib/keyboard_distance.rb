# encoding: utf-8

require "keyboard_distance/version"
require "keyboard_distance/keyboard_layout"

class KeyboardDistance

  attr_reader :max_distance

  SHIFT_DISTANCE = 1.0
  ALT_DISTANCE = 0.5
  SPACE_DISTANCE = 2.0
  UNKNOWN_CHAR_DISTANCE = 0.0

  def initialize(options={})
    @layout = options[:layout] || :qwerty
    raise "Unknown layout :#{@layout}" unless KeyboardLayout.layout_defined?(@layout)

    @national_keys = options[:national_keys] || false
    raise "Unknown national keys #{@national_keys}" unless !@national_keys ||
      KeyboardLayout.national_defined?(@national_keys)

    @shift_distance = options[:shift_distance] || SHIFT_DISTANCE
    @alt_distance = options[:alt_distance] || ALT_DISTANCE
    @space_distance = options[:space_distance] || SPACE_DISTANCE
    @unknown_char_distance = options[:unknown_char_distance] || UNKNOWN_CHAR_DISTANCE

    @distances = calculate_distances
    @max_distance = calculate_max_distance

    @shift_map = KeyboardLayout.build_shifted_keys_map(@layout)
    @alt_map = KeyboardLayout.build_alted_keys_map(@national_keys)
  end

  def similarity(word_1, word_2)
    return nil unless word_1.size == word_2.size

    max_word_length = [word_1.size, word_2.size].max
    1.0 - distance(word_1, word_2) / (max_word_length * @max_distance)
  end

  def distance(word_1, word_2)
    return nil unless word_1.size == word_2.size
    return 0.0 if word_1 == word_2

    dist = 0.0
    word_1.each_char.with_index do |char_1, idx|
      dist += character_distance(char_1, word_2[idx])
    end

    dist
  end

  def character_distance(char_1, char_2)
    return 0.0 if char_1 == char_2
    return @space_distance if char_1 == ' ' || char_2 == ' '
    dist = 0.0

    if @national_keys
      key_1, key_2, difference = unalt_keys(char_1, char_2)
      dist += @alt_distance if difference
    end

    key_1, key_2, difference = unshift_keys(key_1 || char_1, key_2 || char_2)
    dist += @shift_distance if difference

    return dist if key_1 == key_2

    dist + (@distances[keys_signature(key_1, key_2)] || @unknown_char_distance)
  end

  private

  def calculate_distances 
    distances = {}

    KeyboardLayout.foreach_unique_key_pair(@layout) do |key_1, key_2, indexes|
      keys = keys_signature(key_1, key_2)
      next if distances.include?(keys)

      distances[keys] = key_distance(*indexes)
    end

    distances
  end

  def key_distance(idx_11, idx_12, idx_21, idx_22)
    [(idx_11 - idx_21).abs, (idx_12 - idx_22).abs].max
  end

  def keys_signature(key_1, key_2)
   [key_1, key_2].sort.join 
  end

  def unshift_keys(key_1, key_2)
    unshifted_key_1 = @shift_map[key_1] || key_1
    unshifted_key_2 = @shift_map[key_2] || key_2

    difference = (unshifted_key_1 != key_1 && unshifted_key_2 == key_2) ||
                 (unshifted_key_1 == key_1 && unshifted_key_2 != key_2)

    return [unshifted_key_1, unshifted_key_2, difference]
  end

  def unalt_keys(key_1, key_2)
    unalted_key_1 = @alt_map[key_1] || key_1
    unalted_key_2 = @alt_map[key_2] || key_2

    difference = (unalted_key_1 != key_1 && unalted_key_2 == key_2) ||
                 (unalted_key_1 == key_1 && unalted_key_2 != key_2)

    return [unalted_key_1, unalted_key_2, difference]
  end

  def calculate_max_distance
    @distances.values.max + @alt_distance + @shift_distance
  end

end
