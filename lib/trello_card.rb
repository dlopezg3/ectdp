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

  def create_compromises_checklist(retries = 3)
    puts "#{@deal.card_tid} - #{@deal.ecid}"
    checklist_url = "https://api.trello.com/1/cards/#{@deal.card_tid}/checklists?"
    response = HTTParty.post(checklist_url, query: compromise_body_params)
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
      'idLabels': labels
    }
  end

  def compromise_body_params
  {
    'key': "#{ENV['TRELLO_KEY']}",
    'token': "#{ENV['TRELLO_TOKEN']}",
    'name': "Compromisos",
  }
end

  def set_labels
    labels = []

    bank_label = set_bank_label                   if !@deal.credit_entity.empty?
    subsidy_label = set_subsidy_entit             if !@deal.subsidy_entity.empty?
    project_label = set_project_label             if !@deal.proyect_name.empty?
    project_stage_label = set_project_stage_label if !@deal.proyect_stage.empty?

    labels << bank_label.tid          unless bank_label.nil?
    labels << subsidy_label.tid       unless subsidy_label.nil?
    labels << project_label.tid       unless project_label.nil?
    labels << project_stage_label.tid unless project_stage_label.nil?
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

  def set_project_label
    @deal.legal_state.project_labels.find_by(name: @deal.proyect_name)
  end

  def set_project_stage_label
    @deal.legal_state.project_stage_labels.find_by(name: @deal.proyect_stage)
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
    byebug if @deal.ecid == "45018"
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
