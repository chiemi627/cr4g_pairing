require "google_drive"

class Event < ApplicationRecord
    validates :account,
    presence: true,
    uniqueness: true,
    length: {maximum: 16},
    format: {with: /\A[a-z0-9]+\z/i }
    validates :googlesheet,
    presence: true
    validate :is_a_sheet

    def is_a_sheet
        begin
            session = GoogleDrive::Session.from_config("google_drive_config.json")
            sheet = session.spreadsheet_by_key(googlesheet).worksheets[0]
        rescue => error
            errors.add(:googlesheet,error.message)
        end
    end
end
