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
require 'retina-sdk/client/exceptions'
require 'retina-sdk/full_client'

class TestClassifyApi < Test::Unit::TestCase

  POSITIVE_EXAMPLES = ["Shoe with a lining to help keep your feet dry and comfortable on wet terrain." ,
                      "running shoes providing protective cushioning."]
  NEGATIVE_EXAMPLES = ["The most comfortable socks for your feet.",
                      "6 feet USB cable basic white"]

  def setup
    @client = RetinaSDK::FullClient.new(Conf::API_KEY, api_server: Conf::BASE_PATH, retina_name: Conf::RETINA_NAME)
  end

  def test_create_category_filter
    filter_name = "filter1"
    filter1 = @client.create_category_filter(filter_name, POSITIVE_EXAMPLES, negative_examples: NEGATIVE_EXAMPLES)
    assert_true filter1.positions.size > 50
    assert_equal filter_name, filter1.category_name
  end

  def test_exceptions
    expected_exception = false
    begin
      @client.create_category_filter(nil, POSITIVE_EXAMPLES, negative_examples: NEGATIVE_EXAMPLES)
    rescue RetinaSDK::Client::CorticalioError
      expected_exception = true
    end
    assert_true expected_exception

    expected_exception = false
    begin
      @client.create_category_filter("filter_name", [], negative_examples: NEGATIVE_EXAMPLES)
    rescue RetinaSDK::Client::CorticalioError
      expected_exception = true
    end
    assert_true expected_exception

  end

end
