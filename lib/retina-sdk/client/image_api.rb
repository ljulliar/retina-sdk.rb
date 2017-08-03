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
require 'retina-sdk/model/image'


module RetinaSDK
  module Client
    class ImageApi

      def initialize(api_client)
        @api_client = api_client
      end

      # Get images for expressions
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
      #     image_scalar, int: The scale of the image (optional) (optional)
      #     plot_shape, str: The image shape (optional) (optional)
      #     image_encoding, str: The encoding of the returned image (optional)
      #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
      #     Returns: java.io.ByteArrayInputStream
      def get_image_for_expression(retina_name, body, image_scalar=2, plot_shape='circle', image_encoding='base64/png', sparsity=1.0)
        resource_path = '/image'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'image_scalar' => image_scalar, 'plot_shape' => plot_shape,
                         'image_encoding' => image_encoding, 'sparsity' => sparsity }
        post_data = body
        headers = {'Accept' => 'image/png', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params,post_data, headers)
        response.body
      end


      # Get an overlay image for two expressions
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON encoded comparison array to be evaluated (required)
      #     plot_shape, str: The image shape (optional) (optional)
      #     image_scalar, int: The scale of the image (optional) (optional)
      #     image_encoding, str: The encoding of the returned image (optional)
      #     Returns: java.io.ByteArrayInputStream
      def get_overlay_image(retina_name, body, plot_shape='circle', image_scalar=2, image_encoding='base64/png')
        resource_path = '/image/compare'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'plot_shape' => plot_shape, 'image_scalar' => image_scalar,
                         'image_encoding' => image_encoding }
        post_data = body
        headers = {'Accept' => 'image/png', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params,post_data, headers)
        response.body
      end

      # Bulk get images for expressions
      # Args:
      #     retina_name, str: The retina name (required)
      #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
      #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
      #     image_scalar, int: The scale of the image (optional) (optional)
      #     plot_shape, str: The image shape (optional) (optional)
      #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
      #     Returns: Array[Image]
      def get_image_for_bulk_expressions(retina_name, body, get_fingerprint=nil, image_scalar=2, plot_shape='circle', sparsity=1.0)
        resource_path = '/image/bulk'
        verb = 'POST'
        query_params = { 'retina_name' => retina_name, 'plot_shape' => plot_shape, 'image_scalar' => image_scalar,
                         'sparsity' => sparsity, 'get_fingerprint' => get_fingerprint }
        post_data = body
        headers = {'Accept' => 'Application/json', 'Content-Type' => 'application/json'}

        response = @api_client.call_api(resource_path, verb, query_params,post_data, headers)
        JSON.parse(response.body, symbolize_names: true).map { |r| RetinaSDK::Model::Image.new(r) }
      end

    end
  end
end
