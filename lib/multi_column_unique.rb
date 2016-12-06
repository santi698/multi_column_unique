# Concern that generates an unique token and validations according to the class
# unique columns
module MultiColumnUnique
  module Concern
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def validates_hash_uniqueness_of(*fields, condition: nil)
        validates :unique_token, uniqueness: true, allow_nil: true
        before_validation :generate_unique_token

        define_method :generate_unique_token do
          if condition.present? || condition.call(self)
            self.unique_token = Digest::SHA1.hexdigest(fields.map { |k| send(k).to_s }.join)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, MultiColumnUnique::Concern) if defined?(ActiveRecord)
