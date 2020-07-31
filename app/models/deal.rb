require 'active_record/diff'

class Deal < ApplicationRecord
  include ActiveRecord::Diff
  diff exclude: [:id, :created_at, :updated_at, :change_flag, :trello_flag]

  belongs_to :legal_state

  scope :active, -> { joins(:legal_state).where.not(legal_states: {name: "VENDIDA"})
                                         .where.not(legal_states: {name: "ENTREGA DE VIVIENDA"})
                                         .where.not(legal_states: {name: "DESEMBOLSADO"})
                                         .where.not(legal_states: {name: "LIBRE"})
                                       }
end

