class DealsController < ApplicationController
  def index
    @deals = Deal.where(change_flag: true)
                 .or(Deal.where.not(trello_flag: true))
                 .active
                 .with_board
                 .recent
    @deals = @deals.includes(:legal_state).limit(5)
    Deal.create_trello_cards(@deals)
  end
end
