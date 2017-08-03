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
require 'retina-sdk/model/metric'


module RetinaSDK
  module Client
    class CompareApi

      def initialize(api_client)
        @api_client = api_client
      end

      # Compare elements
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON encoded comparison array to be evaluated (required)
      #     Returns: Metric
      #
      def compare(retina_name, body)
        resource_path = '/compare'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        RetinaSDK::Model::Metric.new(JSON.parse(response.body).to_snake_case_symbol_keys)
      end

      # Bulk compare
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: Bulk comparison of elements 2 by 2 (required)
      #     Returns: Array[Metric]
      #
      def compare_bulk(retina_name, body)
        resource_path = '/compare/bulk'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        JSON.parse(response.body).map { |r| RetinaSDK::Model::Metric.new(r.to_snake_case_symbol_keys) }
      end
    end
  end
end
