# -*- coding: utf-8 -*-
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
require 'retina-sdk/lite_client'

class TestLiteClient < Test::Unit::TestCase

INPUT_TEXT =<<TEXT
Martin Luther King, Jr. (January 15, 1929 - April 4, 1968) was an American Baptist minister, activist, humanitarian,
and leader in the African-American Civil Rights Movement. He is best known for his role in the advancement of civil
rights using nonviolent civil disobedience based on his Christian beliefs.

King became a civil rights activist early in his career. He led the 1955 Montgomery Bus Boycott and helped found the
Southern Christian Leadership Conference (SCLC) in 1957, serving as its first president. With the SCLC, King led an
unsuccessful 1962 struggle against segregation in Albany, Georgia (the Albany Movement), and helped organize the 1963
nonviolent protests in Birmingham, Alabama. King also helped to organize the 1963 March on Washington, where he
delivered his famous 'I Have a Dream' speech. There, he established his reputation as one of the greatest orators in
American history.
TEXT

  def setup
    @client = RetinaSDK::LiteClient.new(Conf::API_KEY)
  end

  def test_get_similar_terms
    terms = @client.get_similar_terms(INPUT_TEXT)
    assert_equal 20, terms.size
    terms.each do |term|
      assert_true term.is_a? String
      assert_true term.size > 0
    end

    terms = @client.get_similar_terms((1..500).to_a)
    assert_equal 20, terms.size
    terms.each do |term|
      assert_true term.is_a? String
      assert_true term.size > 0
    end

    begin
      @client.get_similar_terms(45)
      raise 'An exception should have been thrown'
    rescue RetinaSDK::Client::CorticalioError
      # all good
    end

    begin
      @client.get_similar_terms([])
      raise 'An exception should have been thrown'
    rescue RetinaSDK::Client::CorticalioError
      # all good
    end
  end

  def test_get_keywords
    terms = @client.get_keywords(INPUT_TEXT)
    assert_true terms.size > 2
    terms.each do |term|
      assert_true term.is_a? String
      assert_true term.size > 0
    end
  end

  def test_get_fingerprint
    assert_true @client.get_fingerprint('apple').size > 100
    assert_true @client.get_fingerprint('which was the son of').size > 100

    begin
      @client.get_fingerprint('')
      raise 'An exception should have been thrown'
    rescue RetinaSDK::Client::CorticalioError
      # all good
    end
  end

  def test_compare
    apple_string = 'apple'
    banana_string = 'banana is a kind of fruit'
    apple_fingerprint = @client.get_fingerprint(apple_string)
    banana_fingerprint = @client.get_fingerprint(banana_string)
    fingerprint = (1..500).to_a

    assert_true @client.compare(apple_string , banana_string ) > 0.1
    assert_true @client.compare(apple_string , banana_fingerprint) > 0.1
    assert_true @client.compare(apple_fingerprint, banana_string ) > 0.1
    assert_true @client.compare(apple_fingerprint, banana_fingerprint) > 0.1

    assert_true @client.compare(fingerprint, 'language') > 0.1
    assert_true @client.compare(fingerprint, (1..100).to_a) > 0.1
    assert_true @client.compare('language', fingerprint) > 0.1
    assert_true @client.compare(fingerprint, 'Linguistics is the scientific study of language') > 0.1

    begin
      @client.compare('', 2)
      raise 'An exception should have been thrown'
    rescue RetinaSDK::Client::CorticalioError
      # all good
    end
  end

  def test_category_filter
    fingerprint = @client.create_category_filter(['once upon a time', 'lived a noble prince'])
    assert_true fingerprint.is_a? Array
    assert_true fingerprint.size > 50
    assert_true fingerprint[0].is_a? Integer

    begin
      @client.create_category_filter([])
      raise 'An exception should have been thrown'
    rescue RetinaSDK::Client::CorticalioError
      # all good
    end
  end
end
