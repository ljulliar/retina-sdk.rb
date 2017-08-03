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
		class CategoryFilter < RetinaSDK::Model::BaseModel

			attr_reader :category_name, :positions

			def initialize(category_name: nil, positions: nil)
				#The descriptive label for a CategoryFilter name
				@category_name = category_name # str
				#The positions of a Fingerprint
				@positions = positions # list[int]
			end
		end
	end
end
