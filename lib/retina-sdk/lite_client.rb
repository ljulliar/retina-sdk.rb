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

require 'retina-sdk/client/exceptions'
require 'retina-sdk/full_client'

# Minimalistic client for accessing core features of
# Cortical.io's Retina API in a simple way.

module RetinaSDK
  class LiteClient

    def initialize(api_key=nil)
      @full_client = RetinaSDK::FullClient.new(api_key, api_server: "http://api.cortical.io/rest", retina_name: 'en_associative')
    end

    private
    def _create_hash(text_or_fingerprint)
      if text_or_fingerprint.is_a? String
        {'text' => text_or_fingerprint}
      elsif text_or_fingerprint.is_a? Array
        {'positions' => text_or_fingerprint}
      else
        raise RetinaSDK::Client::CorticalioError, "Invalid argument, cannot create input from: '%s'" % text_or_fingerprint
      end
    end

    public
    # Get the similar terms for a given text or fingerprint
    # Args:
    #     text_or_fingerprint, str OR list of integers
    # Returns:
    #     list of str: the 20 most similar terms
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_similar_terms(text_or_fingerprint)
      expression = _create_hash(text_or_fingerprint)
      terms = @full_client.get_similar_terms_for_expression(JSON.dump(expression), max_results: 20)
      terms.map { |t| t.term }
    end

    # Get a list of keywords from the text
    # Args:
    #     text, str: The input document
    # Returns:
    #     list of str
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_keywords(text)
      @full_client.get_keywords_for_text(text)
    end
    # Get the semantic fingerprint of the input text.
    # Args:
    #     text, str: The text to be evaluated
    # Returns:
    #     list of str: the positions of the semantic fingerprint
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def get_fingerprint(text)
      @full_client.get_fingerprint_for_text(text).positions
    end

    # Returns the semantic similarity of texts or fingerprints. Each argument can be eiter a text or a fingerprint.
    # Args:
    #     text_or_fingerprint1, str OR list of integers
    #     text_or_fingerprint2, str OR list of integers
    # Returns:
    #     float: the semantic similarity in the range [0;1]
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def compare(text_or_fingerprint1, text_or_fingerprint2)
      compare_list = [_create_hash(text_or_fingerprint1), _create_hash(text_or_fingerprint2)]
      metric = @full_client.compare(JSON.dump(compare_list))
      metric.cosine_similarity
    end

    # Creates a filter fingerprint.
    # Args:
    #     positiveExamples, list(str): The list of positive example texts.
    # Returns:
    #     list of int: the positions representing the filter representing the texts
    # Raises:
    #     CorticalioError: if the request was not successful
    #
    def create_category_filter(positive_examples)
      category_filter = @full_client.create_category_filter("category_filter", positive_examples)
      category_filter.positions
    end
  end
end
