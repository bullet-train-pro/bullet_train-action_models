module Actions::RequiresApproval
  extend ActiveSupport::Concern

  included do
    belongs_to :approved_by, class_name: "Membership", optional: true
    validates :approved_by, scope: true
    scope :awaiting_approval, -> { where(approved_by: nil, started_at: nil, completed_at: nil) }
    skip_callback :commit, :after, :dispatch
  end

  def valid_approved_bys
    team.memberships
  end

  def approved?
    approved_by_id.present?
  end

  def approve_by(membership)
    update(approved_by: membership)
    dispatch
  end

  def dispatch
    return unless approved_by_id
    super
  end
end
