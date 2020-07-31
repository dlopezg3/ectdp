class DealsController < ApplicationController
  def index
    @deals = Deal.where(change_flag: true)
                 .or(Deal.where.not(trello_flag: true))
                 .active
  end
end
