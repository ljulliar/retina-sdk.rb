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
require 'retina-sdk/model/context'
require 'retina-sdk/model/fingerprint'
require 'retina-sdk/model/term'


module RetinaSDK
  module Client
    class ExpressionsApi

      def initialize(api_client)
        @api_client = api_client
      end

      # """Resolve an expression
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON formatted encoded to be evaluated (required)
      #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
      #     Returns: Fingerprint
      # """
      def resolve_expression(retina_name=nil, body=nil, sparsity=1.0)
        resource_path = '/expressions'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'sparsity' => sparsity }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}
        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        RetinaSDK::Model::Fingerprint.new(JSON.parse(response.body, symbolize_names: true))
      end


      # """Get semantic contexts for the input expression
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
      #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
      #     start_index, int: The start-index for pagination (optional) (optional)
      #     max_results, int: Max results per page (optional) (optional)
      #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
      #     Returns: Array[Context]
      # """
      def get_contexts_for_expression(retina_name=nil, body=nil, get_fingerprint=nil, start_index=0, max_results=5, sparsity=1.0)
        resource_path = '/expressions/contexts'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'start_index' => start_index, 'max_results' => max_results,
                         'sparsity' => sparsity, 'get_fingerprint' => get_fingerprint }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        JSON.parse(response.body, symbolize_names: true).map { |r| RetinaSDK::Model::Context.new(r) }
      end

      # """Get similar terms for the contexts of an expression
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
      #     context_id, int: The identifier of a context (optional) (optional)
      #     pos_type, str: Part of speech (optional) (optional)
      #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
      #     start_index, int: The start-index for pagination (optional) (optional)
      #     max_results, int: Max results per page (optional) (optional)
      #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
      #     Returns: Array[Term]
      # """
      def get_similar_terms_for_expression_context(retina_name, body, context_id=nil, pos_type=nil, get_fingerprint=nil, start_index=0, max_results=10, sparsity=1.0)
        resource_path = '/expressions/similar_terms'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'context_id' => context_id, 'start_index' => start_index,
                           'max_results' => max_results, 'pos_type' => pos_type, 'sparsity' => sparsity,
                           'get_fingerprint' => get_fingerprint }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        JSON.parse(response.body, symbolize_names: true).map { |r| RetinaSDK::Model::Term.new(r) }
      end

      # """Bulk resolution of expressions
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
      #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
      #     Returns: Array[Fingerprint]
      # """
      def resolve_bulk_expression(retina_name, body, sparsity=1.0)
        resource_path = '/expressions/bulk'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'sparsity' => sparsity }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        JSON.parse(response.body, symbolize_names: true).map { |r| RetinaSDK::Model::Fingerprint.new(r) }
      end


      # """Bulk get contexts for input expressions
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
      #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
      #     start_index, int: The start-index for pagination (optional) (optional)
      #     max_results, int: Max results per page (optional) (optional)
      #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
      #     Returns: Array[Context]
      # """
      def get_contexts_for_bulk_expression(retina_name, body, get_fingerprint=nil, start_index=0, max_results=5, sparsity=1.0)
        resource_path = '/expressions/contexts/bulk'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'start_index' => start_index, 'max_results' => max_results,
                         'sparsity' => sparsity, 'get_fingerprint' => get_fingerprint }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        JSON.parse(response.body, symbolize_names: true).map { |r| r.map { |c| RetinaSDK::Model::Context.new(c) } }
      end

      # """Bulk get similar terms for input expressions
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
      #     context_id, int: The identifier of a context (optional) (optional)
      #     pos_type, str: Part of speech (optional) (optional)
      #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
      #     start_index, int: The start-index for pagination (optional) (optional)
      #     max_results, int: Max results per page (optional) (optional)
      #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
      #     Returns: Array[Term]
      def get_similar_terms_for_bulk_expression_context(retina_name, body, context_id=nil, pos_type=nil, get_fingerprint=nil,
                                                        start_index=0, max_results=10, sparsity=1.0)
        resource_path = '/expressions/similar_terms/bulk'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'context_id' => context_id, 'start_index' => start_index,
                         'max_results' => max_results, 'pos_type' => pos_type, 'sparsity' => sparsity,
                         'get_fingerprint' => get_fingerprint }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        JSON.parse(response.body, symbolize_names: true).map { |r| r.map { |t| RetinaSDK::Model::Term.new(t) } }
      end

    end
  end
end
