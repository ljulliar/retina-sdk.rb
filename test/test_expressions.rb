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
require 'test/unit'
require 'configuration'

require 'retina-sdk/full_client'

class TestClientExpressionsAPI < Test::Unit::TestCase

  ONE_TERM_INPUT_JSON = JSON.dump({'term' => 'apple'})
  SIMPLE_EXPRESSION = JSON.dump({'or' => [ {'term' => 'apple'}, {'term' => 'fruit'} ] })
  BULK_INPUT = File.join(File.dirname(__FILE__), 'bulk_input.json')

  def setup
    @client = RetinaSDK::FullClient.new(Conf::API_KEY, api_server: Conf::BASE_PATH, retina_name: Conf::RETINA_NAME)
    # path relative to current working dir
    @json_bulk_expression = File.read(BULK_INPUT)
  end

  def test_expressions
    fp = @client.get_fingerprint_for_expression(ONE_TERM_INPUT_JSON, sparsity: 0.5)
    assert_true fp.positions.size > 100
  end

  def test_contexts
    contexts = @client.get_contexts_for_expression(SIMPLE_EXPRESSION, get_fingerprint: true, start_index: 0, max_results: 3, sparsity: 1.0)
    assert_not_nil contexts
    assert_equal 3, contexts.size
    c0 = contexts[0]
    assert_true c0.fingerprint.positions.size > 100
    assert_true c0.context_label.is_a? String
    assert_equal 0, c0.context_id
  end

  def test_similar_terms
    terms = @client.get_similar_terms_for_expression(SIMPLE_EXPRESSION, context_id: nil, pos_type: 'NOUN', get_fingerprint: true, start_index: 0, max_results: 8, sparsity: 1.0)
    assert_not_nil terms
    assert_equal 8, terms.size
    terms.each do |term|
      assert_not_nil term
      assert_true term.fingerprint.positions.size > 100
      assert_true term.pos_types.include? 'NOUN'
    end
  end

  def test_expression_bulk
    fps = @client.get_fingerprints_for_expressions(@json_bulk_expression)
    assert_equal 6, fps.size
    fps.each do |fp|
      assert_true fp.positions.size > 50
    end
  end

  def test_expression_contexts_bulk
    contexts_lists = @client.get_contexts_for_expressions(@json_bulk_expression, get_fingerprint: true, start_index: 0, max_results: 3)
    assert_equal 6, contexts_lists.size
    contexts_lists.each do |context_list|
      context_list.each_with_index do |context, i|
        assert_true context.fingerprint.positions.size > 45 # At 50 in the Pythin version but smallest value was 48
        assert_true context.context_label.is_a? String
        assert_equal i, context.context_id
      end
    end
  end

  def test_expression_similar_terms_bulk
    terms_lists = @client.get_similar_terms_for_expressions(@json_bulk_expression, get_fingerprint: true, max_results: 7)
    assert_equal 6, terms_lists.size
    terms_lists.each do |term_list|
      assert_equal 7, term_list.size
      assert_true term_list[0].fingerprint.positions.size > 100
    end
  end

end
