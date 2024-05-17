# models/user.rb

class User < ActiveRecord::Base
      before_create :set_default_score

      private
  
      def set_default_score
        self.score ||= 0 
      end
end
  