# frozen_string_literal: true

require 'benchmark'
include Benchmark

require_relative '../lib/sonic_struct'
require 'ostruct'

puts '20,000 instantiations:'

bm 14 do |b|
  b.report 'OpenStruct' do
    20_000.times do
      OpenStruct.new a: 1, b: 2, c: 3
    end
  end

  b.report 'SonicStruct' do
    20_000.times do
      SonicStruct.new a: 1, b: 2, c: 3
    end
  end
end
