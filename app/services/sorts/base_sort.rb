# frozen_string_literal: true

module Sorts
  module BaseSort
    attr_reader :params, :query

    def initialize(query, params)
      @query = query
      @params = params
    end

    def execute
      sort_methods
        .inject(self) { |sorter, method| sorter.send(method) }
        .send(:query).order(id: default_id_order)
    end

    private

    def default_id_order
      :asc
    end

    def sort_methods
      if permissible_sort_keys.include?(sort_by)
        ["by_#{sort_by}"]
      else
        ['by_default']
      end
    end

    def permissible_sort_keys
      raise NotImplementedError,
            "#{self.class.name}#permissible_sort_keys is not implemented yet!"
    end

    def by_default
      raise NotImplementedError,
            "#{self.class.name}#by_default is not implemented yet!"
    end

    def reflect(query)
      @query = query
      self
    end

    def sort_by
      params[:sort_by]&.to_s
    end

    def sort_order
      default_sorting = 'asc'
      return default_sorting if params[:sort_order].nil?

      order = params[:sort_order].to_s.downcase
      %w[asc desc].include?(order) ? order : default_sorting
    end
  end
end
