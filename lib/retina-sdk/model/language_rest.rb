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
    class LanguageRest < RetinaSDK::Model::BaseModel

      attr_reader :language, :iso_tag, :wiki_url

      def initialize(language: nil, iso_tag: nil, wiki_url: nil)
        #Language
        @language = language # str
        #ISO tag
        @iso_tag = iso_tag # str
        #Get Wiki URL
        @wiki_url = wiki_url # str
      end
    end
  end
end
