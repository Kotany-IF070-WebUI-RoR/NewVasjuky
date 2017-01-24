class IssueAttachment < ApplicationRecord
  belongs_to :issue
  mount_uploader :attachment, AttachmentUploader
end
