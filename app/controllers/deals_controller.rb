class DealsController < ApplicationController
  def index
    @deals = Deal.where(trello_flag: true).limit(10).reverse
  end

  def update_cards
    @deals = Deal.unupload
                 .active
                 .recent
    @deals = @deals.includes(:legal_state).limit(10)
    @changed_deals = Deal.with_changes

    Deal.create_trello_cards(@deals)
    redirect_to deals_path
  end
end
