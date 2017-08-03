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
    class Retina < RetinaSDK::Model::BaseModel

      attr_reader :retina_name, :number_of_terms_in_retina, :number_of_rows,
                  :number_of_columns, :description

      def initialize(retina_name: nil, number_of_terms_in_retina: nil, number_of_rows: nil,
                     number_of_columns: nil, description: nil)
        # The identifier of a specific retina
        @retina_name = retina_name # str
        # The number of terms contained in a specific retina
        @number_of_terms_in_retina = number_of_terms_in_retina # long
        # Number of rows of the fingerprints
        @number_of_rows = number_of_rows # int
        # Number of columns of the fingerprints
        @number_of_columns = number_of_columns # int
        # The description of a specific retina
        @description = description # str
      end
    end
  end
end
