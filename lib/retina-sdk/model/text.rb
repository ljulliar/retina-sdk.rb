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
    class Text < RetinaSDK::Model::BaseModel

      attr_reader :text, :fingerprint

      def initialize(text: nil, fingerprint: nil)
        #The text as a string
        @text = text # str
        #The semantic fingerprint representation of the text.
        @fingerprint = (fingerprint.is_a? Hash) ? RetinaSDK::Model::Fingerprint.new(fingerprint) : fingerprint # Fingerprint
      end
    end
  end
end
