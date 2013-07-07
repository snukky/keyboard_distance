# encoding: utf-8

class KeyboardLayout
  
  LAYOUTS = {
    :qwerty => {
      :normal => ['`1234567890-=', ' qwertyuiop[]\\', " asdfghjkl;'", ' zxcvbnm,./'],
      :shift  => ['~!@#$%^&*()_+', ' QWERTYUIOP{}|',  ' ASDFGHJKL:"', ' ZXCVBNM<>?']
    },
    :qwertz => {
      :normal => ['`1234567890-=', ' qwertzuiop[]\\', " asdfghjkl;'", ' yxcvbnm,./'],
      :shift  => ['~!@#$%^&*()_+', ' QWERTZUIOP{}|',  ' ASDFGHJKL:"', ' YXCVBNM<>?']
    }
  }

  NATIONAL_KEYS = {
    :polish => ["ąćęłńóśżźĄĆĘŁŃÓŚŻŹ", "acelnoszzACELNOSZZ"]
  }

  EMPTY_KEY = ' '

  class << self
    def layout_defined?(layout)
      LAYOUTS.keys.include?(layout)
    end

    def national_defined?(national)
      NATIONAL_KEYS.keys.include?(national)
    end

    def build_shifted_keys_map(layout)
      keys = layout_as_array(layout, :normal).flatten
      shifted_keys = layout_as_array(layout, :shift).flatten

      raise "Different number of shifted and unshifted keys for layout" \
        " :#{layout}" unless keys.size == shifted_keys.size

      shift_map = {}
      shifted_keys.each_with_index do |shifted_key, idx|
        shift_map[shifted_key] = keys[idx]
      end

      shift_map
    end

    def build_alted_keys_map(national)
      national_keys = NATIONAL_KEYS[national]
      raise "Undefined national keys #{}" if national_keys.nil?

      raise "Different number of national and ASCII keys for " \
        " :#{national}" unless national_keys[0].size == national_keys[1].size
      
      alt_map = {}
      national_keys[0].split('').each_with_index do |char, idx|
        alt_map[char] = national_keys[1][idx]
      end

      alt_map
    end
    
    def foreach_unique_key_pair(layout, &block)
      keyboard = layout_as_array(layout, :normal)

      keyboard.each_with_index do |row_1, idx_11|
        row_1.each_with_index do |key_1, idx_12|
          keyboard.each_with_index do |row_2, idx_21|
            row_2.each_with_index do |key_2, idx_22|
              next if key_1 == key_2 || key_1 == EMPTY_KEY || key_2 == EMPTY_KEY
              yield key_1, key_2, [idx_11, idx_12, idx_21, idx_22]
            end
          end
        end
      end
    end

    def print_layout(layout, type=:normal)
      keyboard = layout_as_array(layout, type)
      max_row_size = keyboard.map(&:size).max
        
      puts format_header(max_row_size), format_separator(max_row_size)
      keyboard.each_with_index { |keys, idx| puts format_row(idx, keys) }
      puts format_separator(max_row_size)
    end

    private

    def layout_as_array(layout, type=:normal)
      raise "Undefined layout :#{layout}" unless layout_defined?(layout)

      LAYOUTS[layout][type].map{ |line| line.split('') }
    end

    def format_header(length)
      header = "   |"
      length.times{ |i| header << sprintf(" %-3d", i) }
      header
    end

    def format_separator(length)
      separator = " --+"
      length.times{ |i| separator << "---+"}
      separator
    end

    def format_row(idx, keys)
      row = " #{idx} |"
      keys.each{ |k| row << " #{k} |" }
      row
    end
  end

end
