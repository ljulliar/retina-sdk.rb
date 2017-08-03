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
require 'retina-sdk/model/fingerprint'

module RetinaSDK
	module Model
		class Image < RetinaSDK::Model::BaseModel

			attr_reader :fingerprint, :image_data

			def initialize(fingerprint:nil, image_data:nil)
				#The semantic fingerprint representation.
				@fingerprint = (fingerprint.is_a? Hash) ? RetinaSDK::Model::Fingerprint.new(fingerprint) : fingerprint # Fingerprint
				#Image data in base64 encoding.
				@image_data = image_data # list[byte]
			end
		end
	end
end
