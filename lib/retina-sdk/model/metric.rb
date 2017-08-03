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
    class Metric < RetinaSDK::Model::BaseModel

      attr_reader :cosine_similarity, :jaccard_distance, :overlapping_all,
                  :overlapping_left_right, :overlapping_right_left, :size_left,
                  :size_right, :weighted_scoring, :euclidean_distance

      def initialize(cosine_similarity: nil, jaccard_distance: nil, overlapping_all: nil,
                     overlapping_left_right: nil, overlapping_right_left: nil, size_left:nil,
                     size_right: nil, weighted_scoring: nil, euclidean_distance: nil)
        #Get Cosine-Similarity.
        @cosine_similarity = cosine_similarity # float
        #Get Jaccard-Distance.
        @jaccard_distance = jaccard_distance # float
        #Get Overlapping-All.
        @overlapping_all = overlapping_all # int
        #Get Overlapping-Left-Right.
        @overlapping_left_right = overlapping_left_right # float
        #Get Overlapping-Right-Left.
        @overlapping_right_left = overlapping_right_left # float
        #Get Size-left.
        @size_left = size_left # int
        #Get Size-Right.
        @size_right = size_right # int
        #Get the Weighted-Scoring.
        @weighted_scoring = weighted_scoring # float
        #Get Euclidean-Distance.
        @euclidean_distance = euclidean_distance # float
      end
    end
  end
end
