class TrelloCard
  def initialize(deal)
    @deal = deal
    @url = "https://api.trello.com/1/cards"
  end

  def post(retries = 3)
    response = HTTParty.post(@url, query: body_params)
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
    list_id = set_list
    {
      'key': "#{ENV['TRELLO_KEY']}",
      'token': "#{ENV['TRELLO_TOKEN']}",
      'idList': "#{list_id}",
      'name': "#{@deal.ecid}",
      'desc': "#{@deal.proyect_stage}",
      'due': due_date,
      # 'member_ids': "",
      # 'last_activity_date': "",
      'idLabels': labels
      # 'card_members': "",
      # 'pos': "bottom",
    }
  end

  def set_labels
    labels = []

    bank_label = set_bank_label     if !@deal.credit_entity.empty?
    subsidy_label = set_subsidy_entity if !@deal.subsidy_entity.empty?

    labels << bank_label.tid    unless bank_label.nil?
    labels << subsidy_label.tid unless subsidy_label.nil?
    labels
  end

  def set_bank_label
    if aprobado_davivienda?
      legal_state = LegalState.find_by(name: "AVALÚO DAVIVIENDA")
      return legal_state.bank_labels.find_by(name: @deal.credit_entity)
    end
    return @deal.legal_state.bank_labels.find_by(name: @deal.credit_entity)
  end

  def set_subsidy_entity
    if aprobado_davivienda?
      legal_state = LegalState.find_by(name: "AVALÚO DAVIVIENDA")
      return legal_state.subsidy_labels.find_by(name: @deal.subsidy_entity)
    end
    return @deal.legal_state.subsidy_labels.find_by(name: @deal.subsidy_entity )
  end

  def set_due_date
    legal_state_combination = LegalStateDuration.where(legal_state: @deal.legal_state)
                                                .where(credit_entity: @deal.credit_entity)
                                                .where(subsidy_entity: @deal.subsidy_entity)
                                                .first
    return "" if legal_state_combination.nil?
    return "" if legal_state_combination[:days].nil?

    return (@deal.legal_state_date + legal_state_combination[:days].days).to_s
  end

  def set_list
    return @deal.legal_state.list_tid unless aprobado_davivienda?
    return LegalState.find_by(name: "AVALÚO DAVIVIENDA").list_tid
  end

  def aprobado_davivienda?
    if @deal.legal_state.name == "APROBADO" && @deal.credit_entity == "DAVIVIENDA"
      return true
    end
    return false
  end
end
