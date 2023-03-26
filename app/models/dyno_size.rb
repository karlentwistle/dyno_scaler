# frozen_string_literal: true

class DynoSize < ActiveHash::Base
  self.data = [
    { id: 1, code: 'eco', name: 'Eco' },
    { id: 2, code: 'basic', name: 'Basic' },
    { id: 3, code: 'standard-1x', name: 'Standard-1X' },
    { id: 4, code: 'standard-2x', name: 'Standard-2X' },
    { id: 5, code: 'performance-m', name: 'Performance-M' },
    { id: 6, code: 'performance-l', name: 'Performance-L' }
  ]

  def self.smallest
    eco
  end

  def self.largest
    performance_l
  end

  def self.eco
    find_by(code: 'eco')
  end

  def self.basic
    find_by(code: 'basic')
  end

  def self.standard_1x
    find_by(code: 'standard-1x')
  end

  def self.standard_2x
    find_by(code: 'standard-2x')
  end

  def self.performance_m
    find_by(code: 'performance-m')
  end

  def self.performance_l
    find_by(code: 'performance-l')
  end

  def self.base_sizes
    where.not(id: largest.id)
  end

  def self.boost_sizes
    where.not(id: smallest.id)
  end
end
