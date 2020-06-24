# frozen_string_literal: true

# based off test/ostruct/test_ostruct.rb from MRI source

# Copyright (C) 1993-2013 Yukihiro Matsumoto. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

RSpec.describe SonicStruct do
  describe '#initialize' do
    let(:args) { { name: 'John Smith', age: 70, pension: 300 } }

    it 'supports different ways to initialize' do
      expect(described_class.new(args).to_h).to eq(args)
      expect(described_class.new(described_class.new(args)).to_h).to eq(args)
      expect(described_class.new(Struct.new(*args.keys).new(*args.values)).to_h).to eq(args)
    end
  end

  describe '#equality' do
    let(:o1) { described_class.new }
    let(:o2) { described_class.new }

    it 'equals or not' do
      expect(o1).to eq(o2)

      o1.a = 'a'
      expect(o1).not_to eq(o2)

      o2.a = 'a'
      expect(o1).to eq(o2)

      o1.a = 'b'
      expect(o1).not_to eq(o2)

      o2.a = 'b'
      expect(o1).to eq(o2)

      o2.b = 'b'
      expect(o1).not_to eq(o2)

      o1.b = 'b'
      expect(o1).to eq(o2)

      o2 = Object.new
      o2.instance_eval { @table = { a: 'b' } }
      expect(o1).not_to eq(o2)
    end
  end

  describe '#inspect' do
    let(:foo) { described_class.new }

    it 'outputs a helpful string' do
      expect(foo.inspect).to eq("#<#{described_class}>")

      foo.bar = 1
      foo.baz = 2
      expect(foo.inspect).to eq("#<#{described_class} bar=1, baz=2>")

      foo = described_class.new
      foo.bar = described_class.new
      expect(foo.inspect).to eq("#<#{described_class} bar=#<#{described_class}>>")

      foo.bar.foo = foo
      expect(foo.inspect).to eq("#<#{described_class} bar=#<#{described_class} foo=#<#{described_class} ...>>>")
    end
  end

  describe '#frozen' do
    it 'can freeze the object' do
      o = described_class.new
      o.a = 'a'
      o.freeze
      expect { o.b = 'b' }.to raise_error(RuntimeError)
      expect(o).not_to respond_to(:b)

      expect { o.a = 'z' }.to raise_error(RuntimeError)
      expect(o.a).to eq('a')

      o = described_class.new a: 42
      def o.frozen?
        nil
      end

      o.freeze
      expect { o.a = 1764 }.to raise_error(RuntimeError)
    end
  end

  describe '#delete_field' do
    it 'can delete a field' do
      o = described_class.new
      expect(o).not_to respond_to(:a)
      expect(o).not_to respond_to(:a=)

      o.a = 'a'
      expect(o).to respond_to(:a)
      expect(o).to respond_to(:a=)

      a = o.delete_field :a
      expect(o).not_to respond_to(:a)
      expect(o).not_to respond_to(:a=)
      expect(a).to eq('a')
    end
  end

  describe '#[]=' do
    it 'can set attributes' do
      os = described_class.new
      os[:foo] = :bar
      expect(os.foo).to eq(:bar)

      os['foo'] = :baz
      expect(os.foo).to eq(:baz)
    end
  end

  describe '#[]' do
    it 'can get attributes' do
      os = described_class.new
      os.foo = :bar
      expect(os.foo).to eq(:bar)
      expect(os[:foo]).to eq(:bar)
      expect(os['foo']).to eq(:bar)
      expect(os.bar).to eq(nil)
      expect(os[:bar]).to eq(nil)
      expect(os['bar']).to eq(nil)
    end
  end

  describe '#to_h' do
    subject(:to_h) { described_object.to_h }

    let(:args)             { { name: 'John Smith', age: 70, pension: 300 } }
    let(:described_object) { described_class.new(args) }

    it 'returns the hash it was initialized with' do
      expect(to_h).to eq(args)
    end

    context 'when changing the returned hash the object it was generated from does not change' do
      before { to_h[:age] = 71 }

      it 'keeps the original values' do
        expect(os.age).to eq(70)
        expect(os[:age]).to eq(70)
      end
    end

    context 'when initialized with another hash with the same values' do
      it 'returns an equal hash' do
        expect(described_class.new('name' => 'John Smith', 'age' => 70, pension: 300).to_h).to eq(args)
      end
    end
  end

  describe '#each_pair' do
    # h = {name: "John Smith", age: 70, pension: 300}
    # os = described_class.new(h)
    # expect( %Q!#<Enumerator: #<#{described_class} name="John Smith", age=70, pension=300>:each_pair>!, os.each_pair.inspect
    # expect( [[:name, "John Smith"], [:age, 70], [:pension, 300]], os.each_pair.to_a
  end

  describe '#eql_and_hash' do
    # os1 = described_class.new age: 70
    # os2 = described_class.new age: 70.0
    # expect( os1, os2
    # expect( false, os1.eql?(os2)
    # assert_not_equal os1.hash, os2.hash
    # expect( true, os1.eql?(os1.dup)
    # expect( os1.hash, os1.dup.hash
  end
end

# class TC_SonicStruct < Test::Unit::TestCase
#   include Testable_SonicStruct

#   private

#   def described_class
#     SonicStruct
#   end
# end

# class TC_SubSonicStruct < Test::Unit::TestCase
#   class SubSonicStruct < SonicStruct; end

#   include Testable_SonicStruct

#   private

#   def described_class
#     SubSonicStruct
#   end
# end
