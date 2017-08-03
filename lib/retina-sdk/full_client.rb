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

require 'retina-sdk/client/base_client'
require 'retina-sdk/client/classify_api'
require 'retina-sdk/client/compare_api'
require 'retina-sdk/client/expressions_api'
require 'retina-sdk/client/image_api'
require 'retina-sdk/client/retinas_api'
require 'retina-sdk/client/terms_api'
require 'retina-sdk/client/text_api'


# Client for accessing all REST endpoints on Cortical.io's Retina API
module RetinaSDK
  class FullClient

    def initialize(api_key=nil, api_server: 'http://api.cortical.io/rest', retina_name: 'en_associative')
      @retina = retina_name
      # initialization of helper objects
      @base_client = RetinaSDK::Client::BaseClient.new(api_key, api_server)
      @retinas = RetinaSDK::Client::RetinasApi.new(@base_client)
      @terms = RetinaSDK::Client::TermsApi.new(@base_client)
      @text = RetinaSDK::Client::TextApi.new(@base_client)
      @expressions = RetinaSDK::Client::ExpressionsApi.new(@base_client)
      @compare = RetinaSDK::Client::CompareApi.new(@base_client)
      @image = RetinaSDK::Client::ImageApi.new(@base_client)
      @classify = RetinaSDK::Client::ClassifyApi.new(@base_client)
    end

    # Information about retinas
    #    Args:
    #        retinaName, string: The retina name (optional)
    #    Returns:
    #        list of Retina
    #    Raises:
    #        CorticalioError: if the request was not successful
    def get_retinas(retina_name: nil)
      @retinas.get_retinas(retina_name)
    end

    # Get term objects
    #   Args:
    #        term, string: A term in the retina (optional)
    #        get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
    #        start_index, int: The start-index for pagination (optional)
    #        max_results, int: Max results per page (optional)
    #    Returns:
    #        list of Term
    #    Raises:
    #        CorticalioError: if the request was not successful
    def get_terms(term=nil, get_fingerprint: nil, start_index: 0, max_results: 10)
      @terms.get_terms(@retina, term, get_fingerprint, start_index, max_results)
    end

    # Get the contexts for a given term
    # Args:
    #     term, str: A term in the retina (required)
    #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
    #     start_index, int: The start-index for pagination (optional)
    #     max_results, int: Max results per page (optional)
    # Returns:
    #     list of Context
    # Raises:
    #     CorticalioError: if the request was not successful
    def get_contexts_for_term(term=nil, get_fingerprint: nil, start_index: 0, max_results: 5)
      @terms.get_contexts_for_term(@retina, term, get_fingerprint, start_index, max_results)
    end

    # Get the similar terms of a given term
    # Args:
    #     term, str: A term in the retina (required)
    #     context_id, int: The identifier of a context (optional)
    #     pos_type, str: Part of speech (optional)
    #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
    #     start_index, int: The start-index for pagination (optional)
    #     max_results, int: Max results per page (optional)
    # Returns:
    #     list of Term
    # Raises:
    #     CorticalioError: if the request was not successful
    def get_similar_terms_for_term(term=nil, context_id: nil, pos_type: nil, get_fingerprint: nil, start_index: 0, max_results: 10)
      @terms.get_similar_terms(@retina, term, context_id, pos_type, get_fingerprint, start_index, max_results)
    end

    # Get a retina representation of a text
    # Args:
    #     body, str: The text to be evaluated (required)
    # Returns:
    #     Fingerprint
    # Raises:
    #     CorticalioError: if the request was not successful
    def get_fingerprint_for_text(body=nil)
      @text.get_representation_for_text(@retina, body).first
    end

    # Get a list of keywords from the text
    # Args:
    #     body, str: The text to be evaluated (required)
    # Returns:
    #     list of str
    # Raises:
    #     CorticalioError: if the request was not successful
    def get_keywords_for_text(body=nil)
      @text.get_keywords_for_text(@retina, body)
    end

    # Get tokenized input text
    # Args:
    #     body, str: The text to be tokenized (required)
    #     POStags, str: Specify desired POS types (optional)
    # Returns:
    #     list of str
    # Raises:
    #     CorticalioError: if the request was not successful
    def get_tokens_for_text(body=nil, pos_tags: nil)
      @text.get_tokens_for_text(@retina, body, pos_tags)
    end

    # Get a list of slices of the text
    # Args:
    #     body, str: The text to be evaluated (required)
    #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
    #     start_index, int: The start-index for pagination (optional)
    #     max_results, int: Max results per page (optional)
    # Returns:
    #     list of Text
    # Raises:
    #     CorticalioError: if the request was not successful
    def get_slices_for_text(body=nil, get_fingerprint: nil, start_index: 0, max_results: 10)
      @text.get_slices_for_text(@retina, body, get_fingerprint, start_index, max_results)
    end

    # Bulk get Fingerprint for text.
    # Args:
    #     strings, list(str) A list of texts to be evaluated (required)
    #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
    # Returns:
    #     list of Fingerprint
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_fingerprints_for_texts(strings=nil, sparsity: 1.0)
      body = strings.map { |s| {'text' => s} }
      @text.get_representations_for_bulk_text(@retina, JSON.dump(body), sparsity)
    end


    # Detect the language of a text
    # Args:
    #     body, str: Your input text (UTF-8) (required)
    # Returns:
    #     LanguageRest
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_language_for_text(body=nil)
      @text.get_language(@retina, body)
    end

    # Resolve an expression
    # Args:
    #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
    #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
    # Returns:
    #     Fingerprint
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_fingerprint_for_expression(body=nil, sparsity: 1.0)
      @expressions.resolve_expression(@retina, body, sparsity)
    end

    # Get semantic contexts for the input expression
    # Args:
    #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
    #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
    #     start_index, int: The start-index for pagination (optional)
    #     max_results, int: Max results per page (optional)
    #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
    # Returns:
    #     list of Context
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_contexts_for_expression(body=nil, get_fingerprint: nil, start_index: 0, max_results: 5, sparsity: 1.0)
      @expressions.get_contexts_for_expression(@retina, body, get_fingerprint, start_index, max_results, sparsity)
    end

    # Get similar terms for the contexts of an expression
    # Args:
    #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
    #     context_id, int: The identifier of a context (optional)
    #     pos_type, str: Part of speech (optional)
    #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
    #     start_index, int: The start-index for pagination (optional)
    #     max_results, int: Max results per page (optional)
    #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
    # Returns:
    #     list of Term
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_similar_terms_for_expression(body=nil, context_id: nil, pos_type: nil, get_fingerprint: nil, start_index: 0, max_results: 10, sparsity: 1.0)
      @expressions.get_similar_terms_for_expression_context(@retina, body, context_id, pos_type, get_fingerprint, start_index, max_results, sparsity)
    end

    # Bulk resolution of expressions
    # Args:
    #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
    #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
    # Returns:
    #     list of Fingerprint
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_fingerprints_for_expressions(body=nil, sparsity: 1.0)
      @expressions.resolve_bulk_expression(@retina, body, sparsity)
    end

    # Bulk get contexts for input expressions
    # Args:
    #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
    #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
    #     start_index, int: The start-index for pagination (optional)
    #     max_results, int: Max results per page (optional)
    #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
    # Returns:
    #     list of Context
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_contexts_for_expressions(body=nil, get_fingerprint: nil, start_index: 0, max_results: 5, sparsity: 1.0)
      @expressions.get_contexts_for_bulk_expression(@retina, body, get_fingerprint, start_index, max_results, sparsity)
    end

    # Bulk get similar terms for input expressions
    # Args:
    #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
    #     context_id, int: The identifier of a context (optional)
    #     pos_type, str: Part of speech (optional)
    #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
    #     start_index, int: The start-index for pagination (optional)
    #     max_results, int: Max results per page (optional)
    #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
    # Returns:
    #     list of Term
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_similar_terms_for_expressions(body=nil, context_id: nil, pos_type: nil, get_fingerprint: nil, start_index: 0, max_results: 10, sparsity: 1.0)
      @expressions.get_similar_terms_for_bulk_expression_context(@retina, body, context_id, pos_type, get_fingerprint, start_index, max_results, sparsity)
    end

    # Compare elements
    # Args:
    #     body, ExpressionOperation: The JSON encoded comparison array to be evaluated (required)
    # Returns:
    #     Metric
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def compare(body=nil)
      @compare.compare(@retina, body)
    end

    # Bulk compare
    # Args:
    #     body, ExpressionOperation: Bulk comparison of elements 2 by 2 (required)
    # Returns:
    #     list of Metric
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def compare_bulk(body=nil)
      @compare.compare_bulk(@retina, body)
    end

    # Get images for expressions
    # Args:
    #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
    #     imageScalar, int: The scale of the image (optional)
    #     plotShape, str: The image shape (optional)
    #     imageEncoding, str: The encoding of the returned image (optional)
    #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
    # Returns:
    #     str with the raw byte data of the image
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_image(body=nil, image_scalar: 2, plot_shape: 'circle', image_encoding: 'base64/png', sparsity: 1.0)
      @image.get_image_for_expression(@retina, body, image_scalar, plot_shape, image_encoding, sparsity)
    end

    # Get an overlay image for two expressions
    # Args:
    #     body, ExpressionOperation: The JSON encoded comparison array to be evaluated (required)
    #     plotShape, str: The image shape (optional)
    #     imageScalar, int: The scale of the image (optional)
    #     imageEncoding, str: The encoding of the returned image (optional)
    # Returns:
    #     str with the raw byte data of the image
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def compare_image(body=nil, plot_shape: 'circle', image_scalar: 2, image_encoding: 'base64/png')
      @image.get_overlay_image(@retina, body, plot_shape, image_scalar, image_encoding)
    end

    # Bulk get images for expressions
    # Args:
    #     body, ExpressionOperation: The JSON encoded expression to be evaluated (required)
    #     get_fingerprint, bool: Configure if the fingerprint should be returned as part of the results (optional)
    #     imageScalar, int: The scale of the image (optional)
    #     plotShape, str: The image shape (optional)
    #     sparsity, float: Sparsify the resulting expression to this percentage (optional)
    # Returns:
    #     list of Image
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_images(body=nil, get_fingerprint: nil, image_scalar: 2, plot_shape: 'circle', sparsity: 1.0)
      @image.get_image_for_bulk_expressions(@retina, body, get_fingerprint, image_scalar, plot_shape, sparsity)
    end

    # Get a classifier filter (fingerprint) for positive and negative text samples
    # Args:
    #     filterName, str: A unique name for the filter. (required)
    #     positiveExamples, list(str) The list of positive example texts. (required)
    #     negativeExamples, list(str) The list of negative example texts. (optional)
    # Returns:
    #     CategoryFilter
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def create_category_filter(filter_name=nil, positive_examples=[], negative_examples: [])
      samples = { "positiveExamples" => positive_examples.map { |s| {'text' => s} },
                  "negativeExamples" => negative_examples.map { |s| {'text' => s} } }
      body = JSON.dump(samples)
      @classify.create_category_filter(@retina, filter_name, body)
    end
  end
end
