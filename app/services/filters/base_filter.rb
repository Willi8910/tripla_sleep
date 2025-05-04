# frozen_string_literal: true

module Filters
  module BaseFilter
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def execute
      filter_methods
        .inject(self) { |filter, method| filter.send(method) }
        .send(:query)
    end

    private

    def filter_methods
      params
        .slice(*permissible_filter_keys)
        .keys.filter_map { |key| "by_#{key}" }
    end

    def permissible_filter_keys
      raise NotImplementedError,
            "#{self.class.name}#permissible_filter_keys is not implemented yet!"
    end

    def query
      @query ||= base_query
    end

    def base_query
      raise NotImplementedError,
            "#{self.class.name}#base_query is not implemented yet!"
    end

    def reflect(query)
      @query = query
      self
    end
  end
end
