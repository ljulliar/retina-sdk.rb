#------------------------------------------------------------------------------
# Copyright (c) cortical.io GmbH. All rights reserved.
#
# This software is confidential and proprietary information.
# You shall use it only in accordance with the terms of the
# license agreement you entered into with cortical.io GmbH.
#
# Author: Laurent Julliard, 2017. Copyright reassigned to Cortical.io
#------------------------------------------------------------------------------

module RetinaSDK
  class Configuration
    API_KEY = ENV['RETINA_API_KEY']
    BASE_PATH="http://api.cortical.io/rest"
    API_SERVER = BASE_PATH
    RETINA_NAME = "en_associative"
  end
end

Conf = RetinaSDK::Configuration #alias for the class name
