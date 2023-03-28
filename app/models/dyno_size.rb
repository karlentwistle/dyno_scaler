# frozen_string_literal: true

class DynoSize < ActiveHash::Base
  self.data = [
    { id: 1, name: 'Eco' },
    { id: 2, name: 'Basic' },
    { id: 3, name: 'Standard-1X' },
    { id: 4, name: 'Standard-2X' },
    { id: 5, name: 'Performance-M' },
    { id: 6, name: 'Performance-L' }
  ]

  all.each do |dyno_size|
    define_singleton_method(dyno_size.name.downcase.tr('-', '_')) do
      dyno_size
    end
  end

  def self.smallest
    eco
  end

  def self.largest
    performance_l
  end

  def self.base_sizes
    where.not(id: largest.id)
  end

  def self.boost_sizes
    where.not(id: smallest.id)
  end
end
