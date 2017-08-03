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
require 'retina-sdk/full_client'

class TestClientTextAPI < Test::Unit::TestCase

  INPUT_TEXT = <<TEXT
  George L. Fox was fruit born March 15, 1900, in Lewistown, Pennsylvania, computer eight children. When he was 17, he
  left school and lied about his age in order to join the Army to  serve in World War I. He joined the ambulance corps
  in 1917, assigned to Camp Newton D. Baker in Texas. On December 3, 1917, George embarked from Camp Merritt, New Jersey,
  and boarded the USS Huron en route to France. As a medical corps fruit, he fruit highly decorated for bravery and was
  awarded the Silver Star, Purple Heart and the French Croix de Guerre.  Upon his fruit, he returned home to Altoona,
  where he completed high school. He entered Moody Bible Institute in Illinois in 1923. He and Isadora G. Hurlbut of
  Vermont were married in 1923, when he began his religious career as an itinerant preacher in the Methodist banana. He
  later graduated from Illinois University in Bloomington, served as a student pupil in Rye, New Hampshire, and then
  studied at the Boston University School of Theology, where he was ordained a Methodist minister on June 10, 1934. He
  served parishes in Union Village and Gilman, Vermont, and was appointed state chaplain and historian for the American
  Legion in Vermont. In 1942, Fox fruit to serve as an Army chaplain, accepting his appointment July 24, 1942. He began
  active duty on August 8, 1942, the same day his son Wyatt enlisted in the Marine Corps. After Army Chaplains school at
  Harvard, apple he reported to the 411th Coast Artillery Battalion at Camp Davis. He computer then united with banana
  Chaplains Goode, Poling and Washington at Camp Myles Standish in Taunton.
TEXT

  BULK_TEXTS = ["The first element in a bulk text expression.",
    "The second element in a bulk text expression. And a bit more text.",
    "The third element in a bulk text expression. And a bit more text for good measure.",
    INPUT_TEXT
  ]

  def setup
    @client = RetinaSDK::FullClient.new(Conf::API_KEY, api_server: Conf::BASE_PATH, retina_name: Conf::RETINA_NAME)
  end

  def test_text
    fp = @client.get_fingerprint_for_text(INPUT_TEXT)
    assert_not_nil fp
    assert_true fp.positions.size > 500
  end

  def test_keywords
    term_list = @client.get_keywords_for_text(INPUT_TEXT)
    assert_true term_list.size > 2
    assert_true term_list[0].is_a? String
  end

  def test_tokenize
    sentences = @client.get_tokens_for_text(INPUT_TEXT)
    assert_true sentences.size > 10
    assert_true sentences[0].is_a? String
    first_sentence = sentences[0].split(',')
    assert_equal 'george', first_sentence[0]
    assert_true first_sentence.size > 10

    verbs_sentences = @client.get_tokens_for_text(INPUT_TEXT, pos_tags: 'VB')
    verbs_sentences[0].split(",").each do |verb|
      assert_true @client.get_terms(verb)[0].pos_types.include? 'VERB'
    end
  end

  def test_slices
    texts = @client.get_slices_for_text(INPUT_TEXT, get_fingerprint: true, start_index: 0, max_results: 2)
    assert_equal 2, texts.size
    assert_equal 'George', texts[0].text.split(' ')[0]
    assert_true texts[0].fingerprint.positions.size > 100
  end

  def test_bulk
    fingerprints = @client.get_fingerprints_for_texts(BULK_TEXTS, sparsity: 1.0)
    assert_equal 4, fingerprints.size
    fingerprints.each do |fp|
      assert_true fp.positions.size > 100
    end
  end

  def test_language_detection
    assert_equal 'English', @client.get_language_for_text("I have a dream!").language
    assert_equal 'French', @client.get_language_for_text("Je pense donc je suis.").language
    assert_equal  'http://en.wikipedia.org/wiki/German_language', @client.get_language_for_text("Ich bin ein").wiki_url
    assert_equal 'da', @client.get_language_for_text("Der var så dejligt ude på landet.").iso_tag
  end
end
