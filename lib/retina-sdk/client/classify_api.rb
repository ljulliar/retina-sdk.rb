#------------------------------------------------------------------------------
# Copyright (c) cortical.io GmbH. All rights reserved.
#
# This software is confidential and proprietary information.
# You shall use it only in accordance with the terms of the
# license agreement you entered into with cortical.io GmbH.
#
# Author: Laurent Julliard, 2017. Copyright reassigned to Cortical.io
#------------------------------------------------------------------------------

require 'json'
require 'retina-sdk/model/hash_extensions'
require 'retina-sdk/model/category_filter'


module RetinaSDK
  module Client
    class ClassifyApi

      def initialize(api_client)
        @api_client = api_client
      end

      # get filter for classifier
      # Args:
      #     filter_name, str: A unique name for the filter. (required)
      #     body, FilterTrainingObject: The list of positive and negative (optional) example items. (required)
      #     retina_name, str: The retina name (required)
      #     Returns: CategoryFilter
      #
      def create_category_filter(retina_name, filter_name, body)
        resource_path = '/classify/create_category_filter'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'filter_name' => filter_name }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params,post_data, headers)
        RetinaSDK::Model::CategoryFilter.new(JSON.parse(response.body).to_snake_case_symbol_keys)
      end
    end
  end
end
