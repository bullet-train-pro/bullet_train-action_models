module Actions::TracksCreator
  extend ActiveSupport::Concern

  included do
    belongs_to :created_by, class_name: "Membership", optional: true
    validates :created_by, scope: true
  end

  def valid_created_bys
    team.memberships
  end
end
