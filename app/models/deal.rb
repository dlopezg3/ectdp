require 'active_record/diff'
require 'resolv-replace'

class Deal < ApplicationRecord
  require 'trello_card'
  include HTTParty
  include ActiveRecord::Diff

  diff exclude: [:id, :created_at, :updated_at, :change_flag, :trello_flag]

  belongs_to :legal_state

  scope :active, -> { joins(:legal_state).where.not(legal_states: {name: "VENDIDA"})
                                         .where.not(legal_states: {name: "LIBRE"})
                                       }
  scope :recent, -> { where("legal_state_date > ?", DateTime.parse('01/01/2020').to_date) }

  scope :unupload, -> { where(trello_flag: false) }
  scope :with_changes, -> { joins(:legal_state).where(change_flag: true)
                                               .where(legal_states: {name: "PREAPROB Y CONSEC"})
                                             }

  def self.create_trello_cards(deals)
    raise "No se han cargado los estados legales" if LegalState.count == 0
    raise "No se han cargado las labels" if BankLabel.count == 0
    raise "No se han cargado los deals" if Deal.count == 0


    deals.each do |d|
      next if d.legal_state.board_tid.empty?

      card = TrelloCard.new(d)
      card.post
    end
  end
end




