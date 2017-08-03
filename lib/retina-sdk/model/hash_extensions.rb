#------------------------------------------------------------------------------
# Copyright (c) cortical.io GmbH. All rights reserved.
#
# This software is confidential and proprietary information.
# You shall use it only in accordance with the terms of the
# license agreement you entered into with cortical.io GmbH.
#
# Author: Laurent Julliard, 2017. Copyright reassigned to Cortical.io
#------------------------------------------------------------------------------

require 'retina-sdk/model/string_extensions.rb'

class Hash
	def to_snake_case_symbol_keys
		self.keys.each do |key|
			self[key.to_underscore.to_sym] = delete(key)
		end
		self
	end

	def compact
		self.select { |_, value| !value.nil? }
	end
end
