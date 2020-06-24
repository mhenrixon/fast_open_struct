# frozen_string_literal: true

require 'benchmark'
include Benchmark

require_relative '../lib/sonic_struct'
require 'ostruct'

puts 'Attribute assignment:'

bm 14 do |b|
  b.report 'OpenStruct' do
    os = OpenStruct.new a: 1, b: 2, c: 3
    1_000_000.times do
      os.a = 4
      os.b = 5
      os.c = 6
    end
  end

  b.report 'SonicStruct' do
    os = SonicStruct.new a: 1, b: 2, c: 3
    1_000_000.times do
      os.a = 4
      os.b = 5
      os.c = 6
    end
  end
end
