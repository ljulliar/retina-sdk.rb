
#------------------------------------------------------------------------------
# Copyright (c) cortical.io GmbH. All rights reserved.
#
# This software is confidential and proprietary information.
# You shall use it only in accordance with the terms of the
# license agreement you entered into with cortical.io GmbH.
#
# Author: Laurent Julliard, 2017. Copyright reassigned to Cortical.io
#------------------------------------------------------------------------------

require 'net/http'
require 'uri'

require 'retina-sdk/client/exceptions'
require 'retina-sdk/version'

module RetinaSDK
  module Client
    class BaseClient

      attr_reader :api_key, :api_server

      def initialize(api_key, api_server)
        if api_key.nil?
          raise RetinaSDK::Client::CorticalioError, 'You must pass an api_key when instantiating the API Client. Please visit http://www.cortical.io/'
        end
        @api_key = api_key
        @api_server = api_server
        @cookie = nil
      end

      def call_api(resource_path='', verb=nil, query_params={}, post_data={}, headers={})
        url = self.api_server + resource_path
        # puts "\n>>>>>> REQUEST"
        # p resource_path, verb, query_params, post_data, headers

        uri = URI(url)
        # do not pass parameter with nil values (it makes some service
        # end point unhappy : e.g. pos_type in /expressions/similar_terms/bulk)
        uri.query = URI.encode_www_form(query_params.compact)

        if verb == 'GET'
          request = Net::HTTP::Get.new(uri, headers)
        elsif verb == 'POST'
          request = Net::HTTP::Post.new(uri, headers)
          request.body = post_data
        else
          raise RetinaSDK::Client::CorticalioError('Method #{verb} is not recognized.')
        end
        request['api-key'] = self.api_key
        request['api-client'] = "rb_" + RetinaSDK::VERSION
        #response = JSON.dump( {arg: 'val'} ); p request ;return # debug
        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') { |http| http.request(request) }

        if !response.is_a?(Net::HTTPSuccess)
          raise RetinaSDK::Client::CorticalioError, "Response #{response.code}: #{response.body}"
        end
        # puts "\n<<<<< RESPONSE"
        # p response.body
        return response
      end
    end
  end
end
