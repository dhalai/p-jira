class User < ApplicationRecord
  enum role: %i[employee admin manager accountant]

  has_many :auth_identities
  has_many :tasks
end
