require 'active_record/diff'
require 'resolv-replace'

class Deal < ApplicationRecord
  require 'trello_card'
  include HTTParty
  include ActiveRecord::Diff

  diff exclude: [:id, :created_at, :updated_at, :change_flag, :trello_flag]

  belongs_to :legal_state

  scope :active, -> { joins(:legal_state).where.not(legal_states: {name: "VENDIDA"})
                                         .where.not(legal_states: {name: "ENTREGA DE VIVIENDA"})
                                         .where.not(legal_states: {name: "DESEMBOLSADO"})
                                         .where.not(legal_states: {name: "LIBRE"})
                                       }
  scope :with_board, -> { joins(:legal_state).where.not(legal_states: {board_tid: ""})}

  def self.create_trello_cards(deals)
    raise "No se han cargado los estados legales" if LegalState.count == 0
    raise "No se han cargado las labels" if BankLabel.count == 0

    deals.each do |d|
      if !d.legal_state.board_tid.empty?
        card = TrelloCard.new(d)
        card.post
      end
    end
  end
end




