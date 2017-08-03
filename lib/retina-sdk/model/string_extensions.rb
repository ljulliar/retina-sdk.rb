#------------------------------------------------------------------------------
# Copyright (c) cortical.io GmbH. All rights reserved.
#  
# This software is confidential and proprietary information.
# You shall use it only in accordance with the terms of the
# license agreement you entered into with cortical.io GmbH.
#
# Author: Laurent Julliard, 2017. Copyright reassigned to Cortical.io
#------------------------------------------------------------------------------

class String

   # From https://gist.github.com/timcharper/4027440
	 # ruby mutation methods have the expectation to return self if a mutation 
	 # occurred, nil otherwise. (see http://www.ruby-doc.org/core-1.9.3/String.html#method-i-gsub-21)
   def to_underscore!
     g = gsub!(/(.)([A-Z])/,'\1_\2'); d = downcase!
     g || d
   end

   def to_underscore
     dup.tap { |s| s.to_underscore! }
   end

end