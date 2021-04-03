class Auditlog < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true
end
