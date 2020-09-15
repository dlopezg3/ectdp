class DealsController < ApplicationController
  before_action :set_limit, only: %w[index update_cards]
  def index
    @deals = Deal.where(trello_flag: true).sort_by(&:updated_at).reverse[0..(@limit-1)]
  end

  def update_cards
    @deals = Deal.unupload
                 .active
                 .recent
    @deals = @deals.includes(:legal_state) #.limit(@limit)
    @changed_deals = Deal.with_changes

    Deal.create_trello_cards(@deals)
    redirect_to deals_path
  end

  def set_limit
    @limit = 500
  end
end
