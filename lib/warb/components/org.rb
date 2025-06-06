# frozen_string_literal: true

module Warb
  module Components
    class Org
      attr_accessor :company, :department, :title

      def initialize(**params)
        @company = params[:company]
        @department = params[:department]
        @title = params[:title]
      end

      def to_h
        {
          company: company,
          department: department,
          title: title
        }
      end
    end
  end
end
