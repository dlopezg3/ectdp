# rails runner scripts/add_project_labels_to_cards.rb

def update_labels(deal, retries = 3)
  puts "#{deal.card_tid} - #{deal.ecid} - #{deal.legal_state.name}"
  url = "https://api.trello.com/1/cards/#{deal.card_tid}?"
  response = HTTParty.put(url, query: project_label_params(deal))
rescue Net::ReadTimeout => e
  puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
  raise if retries <= 1
  update_labels(retries - 1)
end

def project_label_params(deal)
  labels = set_labels(deal)
  {
    'key': "#{ENV['TRELLO_KEY']}",
    'token': "#{ENV['TRELLO_TOKEN']}",
    'idLabels': labels
  }
end

def set_labels(deal)
  labels = []

  # project_label = set_project_label(deal)             if !deal.proyect_name.empty?
  project_stage_label = set_project_stage_label(deal) if !deal.proyect_stage.empty?
  bank_label = set_bank_label(deal)                   if !deal.credit_entity.empty?
  subsidy_label = set_subsidy_entity(deal)            if !deal.subsidy_entity.empty?

  # labels << project_label.tid       unless project_label.nil?
  labels << project_stage_label.tid unless project_stage_label.nil?
  labels << bank_label.tid          unless bank_label.nil?
  labels << subsidy_label.tid       unless subsidy_label.nil?

  labels
end

# def set_project_label(deal)
#   deal.legal_state.project_labels.find_by(name: deal.proyect_name)
# end

def set_project_stage_label(deal)
  deal.legal_state.project_stage_labels.find_by(name: deal.proyect_stage)
end

def set_bank_label(deal)
  if aprobado_davivienda?(deal)
    legal_state = LegalState.find_by(name: "AVALÚO DAVIVIENDA")
    return legal_state.bank_labels.find_by(name: deal.credit_entity)
  end
  return deal.legal_state.bank_labels.find_by(name: deal.credit_entity)
end

def set_subsidy_entity(deal)
  if aprobado_davivienda?(deal)
    legal_state = LegalState.find_by(name: "AVALÚO DAVIVIENDA")
    return legal_state.subsidy_labels.find_by(name: deal.subsidy_entity)
  end
  return deal.legal_state.subsidy_labels.find_by(name: deal.subsidy_entity )
end

def aprobado_davivienda?(deal)
  return true if deal.legal_state.name == "APROBADO" && deal.credit_entity == "DAVIVIENDA"
  return false
end

deals = Deal.where(trello_flag: true)
deals.each do |deal|
  update_labels(deal)
end
