module Actions::Base
  extend ActiveSupport::Concern

  included do
    after_commit :dispatch, on: [:create]
  end

  module ClassMethods
  end

  def dispatch
    perform
  end

  def before_start
  end

  def after_completion
  end

  def perform
    raise "You need to define `perform`. Did you forget to include `Actions::TargetsMany` or `Actions::TargetsMany`?"
  end
end
