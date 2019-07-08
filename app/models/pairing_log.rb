class PairingLog < ApplicationRecord
    validates :name,
    length: {maximum: 50},
    format: {with: /\A[a-z0-9]+\z/i }
end
