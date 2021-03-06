module ActiveAdmin
  module Inputs
    module AjaxCore
      DEFAULT_LIMIT = 5

      def pluck_column
        klass.reorder("#{method} asc").limit(collection_limit).uniq.pluck(method)
      end

      def input_html_options
        super.merge(
          'data-limit' => collection_limit,
          'data-value-field' => value_field,
          'data-search-fields' => search_fields,
          'data-list-fields' => list_fields,
          'data-ajax-search-fields' => ajax_search_fields,
          'data-ordering' => ordering,
          'data-ransack' => ransack,
          'data-static-ransack' => static_ransack,
          'data-selected-value' => selected_value,
          'data-url' => url,
        )
      end

      def ajax_data
        options[:data] || {}
      end

      def collection_limit
        ajax_data[:limit] || DEFAULT_LIMIT
      end

      def collection_from_association
        super.try(:limit, collection_limit)
      end

      def value_field
        ajax_data[:value_field] || :id
      end

      def search_fields
        ajax_data[:search_fields] || raise(ArgumentError, 'search_fields in required')
      end

      def list_fields
        ajax_data[:list_fields] || raise(ArgumentError, 'list_fields in required')
      end

      def ajax_search_fields
        ajax_data[:ajax_search_fields]
      end

      def ordering
        ajax_data[:ordering] || "#{search_fields.first} ASC"
      end

      def ransack
        ajax_data[:ransack] || "#{search_fields.join('_or_')}_cont"
      end

      def static_ransack
        ajax_data.fetch(:static_ransack, {}).to_json
      end

      def url
        ajax_data[:url] || "#{method.to_s.pluralize}/filter"
      end

      def selected_value
        if @object
          @object.try(:send, input_name)
        end
      end
    end
  end
end
