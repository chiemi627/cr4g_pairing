class Event < ApplicationRecord
    validates :account,
    presence: true,
    uniqueness: true,
    length: {maximum: 16},
    format: {with: /\A[a-z0-9]+\z/i }
    validates :googlesheet,
    presence: true
end
