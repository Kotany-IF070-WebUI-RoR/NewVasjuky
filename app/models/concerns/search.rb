module Search
  extend ActiveSupport::Concern
  module ClassMethods
    def search(query)
      lambda do |args|
        where(query, "%#{args}%", "%#{args}%", "%#{args}%")
      end
    end
  end
end
