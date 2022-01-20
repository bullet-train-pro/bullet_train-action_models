module Actions::CleansUp
  extend ActiveSupport::Concern

  def after_completion
    # Let any other modules finish their work.
    super

    destroy
  end
end
