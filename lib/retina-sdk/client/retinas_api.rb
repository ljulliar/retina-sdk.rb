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
require 'retina-sdk/model/retina'
require 'retina-sdk/model/hash_extensions'


module RetinaSDK
  module Client
    class RetinasApi

      def initialize(api_client)
        @api_client = api_client
      end

      # Information about retinas
      #    Args:
      #      retina_name, str: The retina name (optional) (optional)
      #      Returns: Array[Retina]

      def get_retinas(retina_name=nil)
        resource_path = '/retinas'
        verb = 'GET'
        post_data = nil

        query_params = { 'retina_name' => retina_name }
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params, post_data, headers)
        JSON.parse(response.body).map { |r| RetinaSDK::Model::Retina.new(r.to_snake_case_symbol_keys) }
      end
    end
  end
end
