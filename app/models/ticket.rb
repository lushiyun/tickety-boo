# == Schema Information
#
# Table name: tickets
#
#  id           :integer          not null, primary key
#  title        :string
#  description  :text
#  submitter_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Ticket < ApplicationRecord
  belongs_to :submitter, class_name: 'User'

  has_many :ticket_topics, dependent: :destroy
  has_many :topics, through: :ticket_topics

  has_many :comments, foreign_key: :commented_ticket_id, dependent: :destroy
  has_many :commenters, through: :comments, source: :commenter

  validates :title, :description, :submitter, presence: true

  has_one_attached :attachment

  def self.search(query)
    if query.present?
      where('title LIKE ?', "%#{query}%")
    else
      all
    end
  end

  def self.resolved
    where(resolved: true)
  end

  def self.unresolved
    where(resolved: false)
  end

  def self.public
    where(public: true)
  end

  def self.private
    where(public: false)
  end

  def topics_attributes=(attributes)
    attributes.values.each do |topic_params|
      next unless topic_params[:name].present?

      destroy_or_build_topic(topic_params)
    end
  end

  private

  def destroy_or_build_topic(params)
    topic = Topic.find_or_create_by(name: params[:name])
    if (params[:_destroy] != 'false') && topics.include?(topic)
      topics.destroy(topic)
    else
      ticket_topics.build(topic: topic) unless topics.include?(topic)
    end
  end
end
