class LegalState < ApplicationRecord
  has_many :deals
  has_many :bank_labels, dependent: :destroy
  has_many :subsidy_labels, dependent: :destroy
  has_many :legal_state_durations
  has_many :project_labels, dependent: :destroy
  has_many :project_stage_labels, dependent: :destroy
end
