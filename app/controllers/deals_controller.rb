class DealsController < ApplicationController
  def index
    @deals = Deal.where(change_flag: true)
                 .or(Deal.where.not(trello_flag: true))
                 .active
                 .with_board
    @deals = @deals.includes(:legal_state).limit(5)
    Deal.iterate_over_deals(@deals)
  end
end
