require 'active_record/diff'
require 'resolv-replace'

class Deal < ApplicationRecord
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
  def self.iterate_over_deals(deals)
    deals.each do |d|
      post_card(d) if !d.legal_state.board_tid.empty?
    end
  end

  private

  def self.post_card(d, retries = 3)
    params = body_params(d)
    url = "https://api.trello.com/1/cards"
    # byebug
    p d
    p d.legal_state.name
    response = HTTParty.post(url, query: params)
    d.update(trello_flag: true, change_flag: false)
  rescue Net::OpenTimeout => e
    puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
    if retries <= 1
      raise
    end
    post_card(d, retries - 1)
  end

  def self.body_params(deal)
    {
      'key': "#{ENV['TRELLO_KEY']}",
      'token': "#{ENV['TRELLO_TOKEN']}",
      'idList': "#{deal.legal_state.list_tid}",
      'name': "#{deal.ecid}",
      'desc': "#{deal.proyect_stage}",
      # 'due': "",
      'board_id': "#{deal.legal_state.board_tid}"
      # 'member_ids': "",
      # 'last_activity_date': "",
      # 'card_labels': "",
      # 'card_members': "",
      # 'pos': "bottom",
    }
  end
end

