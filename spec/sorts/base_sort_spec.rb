# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sorts::BaseSort do
  let(:dummy_sort_class) do
    Class.new do
      include Sorts::BaseSort
    end
  end

  let(:query) { double('ActiveRecord::Relation') }
  let(:params) { {} }
  let(:sort_instance) { dummy_sort_class.new(query, params) }

  describe '#permissible_sort_keys' do
    it 'raises NotImplementedError when not implemented' do
      expect { sort_instance.send(:permissible_sort_keys) }
        .to raise_error(NotImplementedError, /permissible_sort_keys is not implemented yet!/)
    end
  end

  describe '#by_default' do
    it 'raises NotImplementedError when not implemented' do
      expect { sort_instance.send(:by_default) }
        .to raise_error(NotImplementedError, /by_default is not implemented yet!/)
    end
  end
end
