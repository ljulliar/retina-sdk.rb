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
require 'retina-sdk/model/term'


module RetinaSDK
  module Client
    class TermsApi

        def initialize(api_client)
            @api_client = api_client
        end

            # """Get term objects
            # Args:
            #     retina_name, str: The retina name (required)
            #     term, str: A term in the retina (optional) (optional)
            #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
            #     start_index, int: The start-index for pagination (optional) (optional)
            #     max_results, int: Max results per page (optional) (optional)
            #     Returns: Array[Term]
            # """
        def get_terms(retina_name=nil, term=nil, get_fingerprint=nil, start_index=0, max_results=10)
            resource_path = '/terms'
            verb = 'GET'
            query_params = { 'retina_name' => retina_name, 'term' => term, 'start_index' => start_index,
                             'max_results' => max_results, 'get_fingerprint' => get_fingerprint }
            post_data = nil
            headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

            response = @api_client.call_api(resource_path, verb, query_params,post_data, headers)
            JSON.parse(response.body, symbolize_names: true).map { |r| RetinaSDK::Model::Term.new(r) }
        end

            # """Get the contexts for a given term
            # Args:
            #     retina_name, str: The retina name (required)
            #     term, str: A term in the retina (required)
            #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
            #     start_index, int: The start-index for pagination (optional) (optional)
            #     max_results, int: Max results per page (optional) (optional)
            #     Returns: Array[Context]
            # """
        def get_contexts_for_term(retina_name=nil, term=nil, get_fingerprint=nil, start_index=0, max_results=5)
            resource_path = '/terms/contexts'
            verb = 'GET'
            query_params = { 'retina_name' => retina_name, 'term' => term, 'start_index' => start_index,
                             'max_results' => max_results, 'get_fingerprint' => get_fingerprint }
            post_data = nil
            headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

            response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
            JSON.parse(response.body, symbolize_names: true).map { |r| RetinaSDK::Model::Context.new(r) }
        end

            # """Get the similar terms of a given term
            # Args:
            #     retina_name, str: The retina name (required)
            #     term, str: A term in the retina (required)
            #     context_id, int: The identifier of a context (optional) (optional)
            #     pos_type, str: Part of speech (optional) (optional)
            #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
            #     start_index, int: The start-index for pagination (optional) (optional)
            #     max_results, int: Max results per page (optional) (optional)
            #     Returns: Array[Term]
            # """
        def get_similar_terms(retina_name=nil, term=nil, context_id=nil, pos_type=nil, get_fingerprint=nil, start_index=0, max_results=10)
            resource_path = '/terms/similar_terms'
            verb = 'GET'
            post_data = nil
            query_params = { 'retina_name' => retina_name, 'term' => term, 'context_id' => context_id,
                             'start_index' => start_index, 'max_results' => max_results, 'pos_type' => pos_type,
                             'get_fingerprint' => get_fingerprint }
            headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

            response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
            JSON.parse(response.body, symbolize_names: true).map { |r| RetinaSDK::Model::Term.new(r) }
        end
    end
  end
end
