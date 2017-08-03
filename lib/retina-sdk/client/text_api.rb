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
require 'retina-sdk/model/fingerprint'
require 'retina-sdk/model/language_rest'
require 'retina-sdk/model/text'


module RetinaSDK
  module Client
    class TextApi

      def initialize(api_client)
        @api_client = api_client
      end

      # Get a retina representation of a text
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, str: The text to be evaluated (required)
      #     Returns: Array[Fingerprint]
      def get_representation_for_text(retina_name, body)
        resource_path = '/text'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        JSON.parse(response.body, symbolize_names: true).map { |r| RetinaSDK::Model::Fingerprint.new(r) }
      end

      # Get a list of keywords from the text
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, str: The text to be evaluated (required)
      #     Returns: Array[str]
      def get_keywords_for_text(retina_name, body)
        resource_path = '/text/keywords'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params,post_data, headers)

        JSON.parse(response.body, symbolize_names: true)
      end

      # Get tokenized input text
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, str: The text to be tokenized (required)
      #     POStags, str: Specify desired POS types (optional)
      #     Returns: Array[str]
      def get_tokens_for_text(retina_name, body, pos_tags=nil)
        resource_path = '/text/tokenize'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'POStags' => pos_tags }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)

        JSON.parse(response.body, symbolize_names: true)
      end

      # Get a list of slices of the text
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, str: The text to be evaluated (required)
      #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
      #     start_index, int: The start-index for pagination (optional) (optional)
      #     max_results, int: Max results per page (optional) (optional)
      #     Returns: Array[Text]
      def get_slices_for_text(retina_name, body, get_fingerprint=nil, start_index=0, max_results=10)
        resource_path = '/text/slices'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'start_index' => start_index, 'max_results' => max_results,
          'get_fingerprint' => get_fingerprint }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        JSON.parse(response.body, symbolize_names: true).map { |r| RetinaSDK::Model::Text.new(r) }
      end

      # Bulk get Fingerprint for text.
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
      #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
      #     Returns: Array[Fingerprint]
      def get_representations_for_bulk_text(retina_name, body, sparsity=1.0)
        resource_path = '/text/bulk'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'sparsity' => sparsity }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        JSON.parse(response.body, symbolize_names: true).map { |r| RetinaSDK::Model::Fingerprint.new(r) }
      end

      # Detect the language of a text
      # Args:
      #     body, str: Your input text (UTF-8) (required)
      #     Returns: LanguageRest
      def get_language(retina_name, body)
        resource_path = '/text/detect_language'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name}
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        RetinaSDK::Model::LanguageRest.new(JSON.parse(response.body, symbolize_names: true))
      end
    end
  end
end
