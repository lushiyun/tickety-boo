class Ticket < ApplicationRecord
  belongs_to :submitter, class_name: "User"
end
