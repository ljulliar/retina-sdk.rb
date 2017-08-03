#------------------------------------------------------------------------------
# Copyright (c) cortical.io GmbH. All rights reserved.
#
# This software is confidential and proprietary information.
# You shall use it only in accordance with the terms of the
# license agreement you entered into with cortical.io GmbH.
#
# Author: Laurent Julliard, 2017. Copyright reassigned to Cortical.io
#------------------------------------------------------------------------------

require 'test/unit'
require 'configuration'
require 'retina-sdk/full_client'

class TestClientTermsAPI < Test::Unit::TestCase

  def setup
    @client = RetinaSDK::FullClient.new(Conf::API_KEY, api_server: Conf::BASE_PATH, retina_name: Conf::RETINA_NAME)
  end

  def test_terms
    terms = @client.get_terms('apple', get_fingerprint: true, start_index: 0, max_results: 5)
    assert_equal 1, terms.size
    assert_equal 'apple', terms[0].term
    assert_true terms[0].pos_types.include? 'NOUN'
    assert_true terms[0].df > 0.0001
    assert_true terms[0].fingerprint.positions.size > 100

    terms100 = @client.get_terms('app*', start_index: 0, max_results: 100)
    assert_equal 100, terms100.size
  end

  def test_contexts
    contexts = @client.get_contexts_for_term('apple', get_fingerprint: true, start_index: 0, max_results: 3)
    assert_not_nil contexts
    assert_equal 3, contexts.size
    c0 = contexts[0]
    assert_true c0.fingerprint.positions.size > 100
    assert_true c0.context_label.is_a? String
    assert_equal 0, c0.context_id
  end

  def test_similar_terms
    terms = @client.get_similar_terms_for_term('apple', context_id: 0, pos_type: 'NOUN', get_fingerprint: true, start_index: 0, max_results: 8)
    assert_not_nil terms
    assert_equal 8, terms.size
    t0 = terms[0]
    assert_true t0.fingerprint.positions.size > 0
    assert_not_nil t0
    assert_true t0.pos_types.include? 'NOUN'
  end

  def test_exception_terms
    assert_raise RetinaSDK::Client::CorticalioError do
      @client.get_similar_terms_for_term('apple', pos_type: 'wrong')
    end
  end

end
