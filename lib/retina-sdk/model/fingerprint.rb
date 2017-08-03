#------------------------------------------------------------------------------
# Copyright (c) cortical.io GmbH. All rights reserved.
#
# This software is confidential and proprietary information.
# You shall use it only in accordance with the terms of the
# license agreement you entered into with cortical.io GmbH.
#
# Author: Laurent Julliard, 2017. Copyright reassigned to Cortical.io
#------------------------------------------------------------------------------

require 'retina-sdk/model/base_model'

module RetinaSDK
	module Model
		class Fingerprint < RetinaSDK::Model::BaseModel

			attr_reader :positions

			def initialize(positions: nil)
				# Get Fingerprint Positions.
				@positions = positions # list[int]
			end
		end
	end
end
