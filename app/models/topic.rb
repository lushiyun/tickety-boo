# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Topic < ApplicationRecord
  has_many :ticket_topics, dependent: :destroy
  has_many :tickets, through: :ticket_topics

  has_many :post_topics, dependent: :destroy
  has_many :posts, through: :post_topics

  validates :name, presence: true, uniqueness: true
end
