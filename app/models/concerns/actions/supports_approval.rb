module Actions::SupportsApproval
  extend ActiveSupport::Concern

  # define relationships.
  included do
    belongs_to :approved_by, class_name: "Membership", optional: true
    validates :approved_by, scope: true
  end

  # define class methods.
  module ClassMethods
  end

  def valid_approved_bys
    team.memberships
  end
end
