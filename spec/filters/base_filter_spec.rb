# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filters::BaseFilter do
  let(:dummy_filter_class) do
    Class.new do
      include Filters::BaseFilter
    end
  end

  let(:params) { {} }
  let(:filter_instance) { dummy_filter_class.new(params) }

  describe '#permissible_filter_keys' do
    it 'raises NotImplementedError when not implemented' do
      expect { filter_instance.send(:permissible_filter_keys) }
        .to raise_error(NotImplementedError, /permissible_filter_keys is not implemented yet!/)
    end
  end

  describe '#base_query' do
    it 'raises NotImplementedError when not implemented' do
      expect { filter_instance.send(:base_query) }
        .to raise_error(NotImplementedError, /base_query is not implemented yet!/)
    end
  end
end
