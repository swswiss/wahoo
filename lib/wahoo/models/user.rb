# frozen_string_literal: true

module Wahoo
  module Models
    class User < Base
      property :id
      property :email
      property :first
      property :last
      property :height        
      property :weight           
      property :birth, as: :date
      property :gender
      property :created_at, as: :time
      property :updated_at, as: :time

      def name
        [first, last].compact.join(" ").strip
      end

      def gender_label
        { 0 => "male", 1 => "female", 2 => "other", 3 => "prefer not to say" }[gender]
      end
    end
  end
end
