#------------------------------------------------------------------------------
# Copyright (c) cortical.io GmbH. All rights reserved.
#
# This software is confidential and proprietary information.
# You shall use it only in accordance with the terms of the
# license agreement you entered into with cortical.io GmbH.
#
# Author: Laurent Julliard, 2017. Copyright reassigned to Cortical.io
#------------------------------------------------------------------------------

# Check Ruby version. We used named parameters that are only
# supported in Ruby 2.0 and above
major, minor, teeny = RUBY_VERSION.split('.')
raise(RetinaSDK::Client::CorticalioError, "This gem requires ruby 2.0 or above") if major == '1'

require "retina-sdk/version"
require "retina-sdk/full_client"
require "retina-sdk/lite_client"

module RetinaSDK
  # No code here for no
end
