module Shareable
  extend ActiveSupport::Concern

  included do
    after_commit :share_content
  end

  def share_content
    User.share_content(share_list, self)
    self.shares.delete_all
  end
end
