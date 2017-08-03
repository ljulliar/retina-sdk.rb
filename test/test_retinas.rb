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

class TestClientRetinasAPI < Test::Unit::TestCase

	def setup
		@client = RetinaSDK::FullClient.new(Conf::API_KEY, api_server: Conf::BASE_PATH, retina_name: Conf::RETINA_NAME)
	end

	def test_all_retinas
		retinas = @client.get_retinas()
		assert_not_nil retinas
		assert_equal 2, retinas.size
		assert_not_nil retinas[0]
		assert_not_nil retinas[1]
		assert_true ['en_synonymous', 'en_associative'].include? retinas[0].retina_name
		assert_true ['en_synonymous', 'en_associative'].include? retinas[1].retina_name
		assert_true retinas[0].number_of_terms_in_retina > 50000
	end

	def test_one_retina
		retinas = @client.get_retinas(retina_name: 'en_associative')
		assert_equal retinas.size, 1
		assert_equal 'en_associative', retinas[0].retina_name
	end

	def test_exception
		exception_raised = false
		begin
			@client.get_retinas(retina_name: 'non_existing_retina')
		rescue RetinaSDK::Client::CorticalioError
			exception_raised = true
		end
		assert_true exception_raised
	end

end
