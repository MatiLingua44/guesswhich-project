# models/user.rb

require 'bcrypt'
require 'securerandom'
class User < ActiveRecord::Base
      before_create :set_default_score
      has_secure_password

      def generate_password_reset_token!
        self.password_reset_token = SecureRandom.urlsafe_base64
        self.password_reset_sent_at = Time.now.utc
        save!
      end

      def clear_password_reset_token!
        self.password_reset_token = nil
        self.password_reset_sent_at = nil
        save!
      end
  
      def set_default_score
        self.score ||= 0 
      end
end
  