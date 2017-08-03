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
  module Model
    class BaseModel
      def inspect
        ivars_list = self.instance_variables.collect { |iv| "%s=%s" % [iv, instance_variable_get(iv).inspect] }
        return "%s(%s)" % [self.class.name.split('::').last, ivars_list.join(", ")]
      end
    end
  end
end
