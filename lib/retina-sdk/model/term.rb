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
    class Term < RetinaSDK::Model::BaseModel

      attr_reader :fingerprint, :term, :df, :pos_types, :score

      def initialize(fingerprint: nil, term: nil, df: nil, pos_types: nil, score: nil)
        #The Fingerprint of this term.
        @fingerprint = (fingerprint.is_a? Hash) ? RetinaSDK::Model::Fingerprint.new(fingerprint) : fingerprint # Fingerprint
        #The term as a string.
        @term = term # str
        #The df value of this term.
        @df = df # float
        #The pos types of the term.
        @pos_types = pos_types # list[str]
        #The score of this term.
        @score = score # float
      end
    end
  end
end
