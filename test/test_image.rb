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

class TestClientImageAPI < Test::Unit::TestCase

  INPUT_JSON = '{ "term" : "apple" }'
  INPUT_JSON_ARRAY = '[ { "term" : "apple" }, { "term" : "banana" } ]'
  INPUT_JSON_ARRAY3 = '[ { "term" : "apple" }, { "term" : "banana" }, { "term" : "fruit" } ]'

  # INFO:
  # 'base64/png' image data can be written to disk like this (python2.7):
  #
  # File.open('image_to_save.png', 'wb') do|f|
  #   f.write(Base64.decode64(image_data))
  # end
  #

  def setup
    @client = RetinaSDK::FullClient.new(Conf::API_KEY, api_server: Conf::BASE_PATH, retina_name: Conf::RETINA_NAME)
  end

  def test_image
    image_data = @client.get_image(INPUT_JSON)
    assert_not_nil image_data
    assert_true image_data.size > 1000
  end

  def test_compare
    image_data = @client.compare_image(INPUT_JSON_ARRAY)
    assert_not_nil image_data
    assert_true image_data.size > 1000
  end

  def test_bulk
    images = @client.get_images(INPUT_JSON_ARRAY3, get_fingerprint: true)
    assert_equal 3, images.size
    images.each do |image|
      assert_not_nil image
      assert_not_nil image.image_data
      assert_true image.image_data.size > 1000
      assert_true image.fingerprint.positions.size > 50
    end
  end

end
