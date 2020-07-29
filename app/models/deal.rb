require 'active_record/diff'

class Deal < ApplicationRecord
  include ActiveRecord::Diff
  diff exclude: [:id, :created_at, :updated_at, :change_flag, :trello_flag]
end



