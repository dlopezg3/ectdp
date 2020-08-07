class TrelloCard
  def initialize(deal)
    @deal = deal
    @url = "https://api.trello.com/1/cards"
  end

  def post(retries = 3)
    params = body_params
    response = HTTParty.post(@url, query: params)
    @deal.update(trello_flag: true, change_flag: false, card_tid: response["id"])
  rescue => e
    puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
    raise if retries <= 1
    post(retries - 1)
  end

  private

  def body_params
    labels = set_labels
    due_date = set_due_date
    # list_id = set_list
    {
      'key': "#{ENV['TRELLO_KEY']}",
      'token': "#{ENV['TRELLO_TOKEN']}",
      'idList': "#{@deal.legal_state.list_tid}",
      'name': "#{@deal.ecid}",
      'desc': "#{@deal.proyect_stage}",
      'due': due_date,
      'board_id': "#{@deal.legal_state.board_tid}",
      # 'member_ids': "",
      # 'last_activity_date': "",
      'idLabels': labels
      # 'card_members': "",
      # 'pos': "bottom",
    }
  end

  def set_labels
    labels = []
    if !@deal.credit_entity.empty?
      bank_label = @deal.legal_state.bank_labels.find_by(name: @deal.credit_entity)
    end
    if !@deal.subsidy_entity.empty?
      subsidy_label = @deal.legal_state.subsidy_labels.find_by(name: @deal.subsidy_entity )
    end
    labels << bank_label.tid unless bank_label.nil?
    labels << subsidy_label.tid unless subsidy_label.nil?
    labels
  end

  def set_due_date
    legal_state_combination = LegalStateDuration.where(legal_state: @deal.legal_state)
                                                .where(credit_entity: @deal.credit_entity)
                                                .where(subsidy_entity: @deal.subsidy_entity)
                                                .first
    return "" if legal_state_combination.nil?

    return (@deal.legal_state_date + legal_state_combination[:days].days).to_s
  end
end
