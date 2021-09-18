# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Voteable
  include Commentable

  belongs_to :user

  has_many :answers, -> { order('best DESC, created_at') }, dependent: :destroy
  has_many_attached :files
  has_many :subscriptions, dependent: :destroy
  has_one :reward, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  after_create :subscribe_author

  private

  def subscribe_author
    subscriptions.create(user: author)
  end
end
