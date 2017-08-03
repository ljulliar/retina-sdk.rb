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
require 'json'
require 'retina-sdk/client/exceptions'
require 'retina-sdk/full_client'

class TestClientCompareApi < Test::Unit::TestCase

  INPUT_JSON_ARRAY =  JSON.dump([{ "term" => "apple" }, { "text" => "banana is a kind of fruit" }])
  BULK_JSON_ARRAY = JSON.dump([ [{"term" => "jaguar" }, {"term" => "car" }], [{ "term" => "jaguar" }, {"term" => "cat"}] ])
  ONE_TERM_INPUT_JSON_ARRAY = JSON.dump([{"term" => "apple"}])
  SYNTAX_ERROR_JSON_ARRAY = JSON.dump([{"invalid_key" => "apple" }, {"term" => "banana"}])

  def setup
    @client = RetinaSDK::FullClient.new(Conf::API_KEY, api_server: Conf::BASE_PATH, retina_name: Conf::RETINA_NAME)
  end

  def test_compare
    result_metric = @client.compare(INPUT_JSON_ARRAY)
    assert_true result_metric.cosine_similarity > 0.1
    assert_true result_metric.euclidean_distance > 0.1
    assert_true result_metric.jaccard_distance > 0.1
    assert_true result_metric.weighted_scoring > 0.1
    assert_true result_metric.size_right > 10
    assert_true result_metric.size_left > 10
    assert_true result_metric.overlapping_left_right > 0.1
    assert_true result_metric.overlapping_all > 10
    assert_true result_metric.overlapping_right_left > 0.1
  end

  def test_compare_bulk
    result_metric_list = @client.compare_bulk(BULK_JSON_ARRAY)
    assert_equal 2, result_metric_list.size
    result_metric_list.each do |result_metric|
      assert_true result_metric.cosine_similarity > 0.1
      assert_true result_metric.euclidean_distance > 0.1
      assert_true result_metric.jaccard_distance > 0.1
      assert_true result_metric.weighted_scoring > 0.1
      assert_true result_metric.size_right > 10
      assert_true result_metric.size_left > 10
      assert_true result_metric.overlapping_left_right > 0.1
      assert_true result_metric.overlapping_all > 10
      assert_true result_metric.overlapping_right_left > 0.1
    end
  end

  def test_exception
    # testing using only one input element in the array
    expected_exception = false
    begin
      @client.compare(ONE_TERM_INPUT_JSON_ARRAY)
    rescue RetinaSDK::Client::CorticalioError
      expected_exception = true
    end
    assert_true expected_exception

    # testing JSON parse exception in the input
    expected_exception = false
    begin
      @client.compare(SYNTAX_ERROR_JSON_ARRAY)
    rescue RetinaSDK::Client::CorticalioError
      expected_exception = true
    end
    assert_true expected_exception
  end

end
