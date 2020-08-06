class LegalState < ApplicationRecord
  has_many :deals
  has_many :bank_labels, dependent: :destroy
  has_many :subsidy_labels, dependent: :destroy
end
