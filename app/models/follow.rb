class Follow < Socialization::ActiveRecordStores::Follow
  scope :find_followers, ->(id) { where(followable: id) }
end
