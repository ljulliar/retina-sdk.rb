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
require 'retina-sdk/client/base_client'

class TestBaseClient < Test::Unit::TestCase

	def test_base_client_connection
		api_client = RetinaSDK::Client::BaseClient.new(Conf::API_KEY, Conf::API_SERVER)
		assert_nothing_raised RetinaSDK::Client::CorticalioError do
			api_client.call_api('/retinas', 'GET')
		end
	end

end
