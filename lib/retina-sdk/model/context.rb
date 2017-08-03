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

    class Context < RetinaSDK::Model::BaseModel

      attr_reader :fingerprint, :context_label, :context_id

      def initialize(fingerprint: nil, context_label: nil, context_id: nil)
        #The semantic fingerprint representation of a context
        @fingerprint = (fingerprint.is_a? Hash) ? Fingerprint.new(fingerprint) : fingerprint # Fingerprint
        #The descriptive label of a context.
        @context_label = context_label # str
        #The id of a context.
        @context_id = context_id # int
      end
    end
  end
end
