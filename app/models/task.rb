class Task < ApplicationRecord
  belongs_to :user, optional: true

  enum status: %i[opened in_progress done]
end
