# rails runner scripts/deals_migration.rb
require 'csv'
require_relative 'ls_equivalents'

csv_options = { col_sep: ';', force_quotes: true, quote_char: '"', headers: true}
filepath = 'app/data/deals_files/INFORME_DE_ESTADOS_LEGALES.csv'

def record_exists?(deal)
  !Deal.find_by(ecid: deal[:ecid]).nil?
end

def compare_changes(deal, params)
  original_deal = Deal.find_by(ecid: deal[:ecid])
  if deal.diff?(original_deal)
    original_deal.update(params)
    change_flag_status_true(original_deal, deal)
  elsif deal.legal_state_id != original_deal.legal_state_id
    new_legal_state = LegalState.find(deal.legal_state_id)
    original_deal.update(legal_state: new_legal_state)
    change_flag_status_true(original_deal, deal)
  else
    original_deal.update(change_flag: false)
  end
end

def change_flag_status_true(original_deal, deal)
  original_deal.update(change_flag: true)
  puts "Actualizando negocio #{original_deal.ecid} - Estado en dinamia: #{deal.legal_state_dinamia}"
end

def set_deal_legal_state(deal, legal_state)
  legal_trello_state = LS_EQUIVALENTS[legal_state.to_sym]
  db_legal_state  = LegalState.find_by(name: legal_trello_state)
  abort "OJO ------------------- No existe en Trello el estado legal: #{legal_state}" if invalid_status(deal, db_legal_state)

  deal.legal_state = LegalState.find_by(name: legal_trello_state)
  if deal.legal_state == "APROBADO" and deal.credit_entity == "DAVIVIENDA"
    deal.legal_state_date = LegalState.find_by(name: "APROBADO DAVIVIENDA")
  end
  deal
end

def invalid_status(deal, db_legal_state)
  return false if !db_legal_state.nil?
  return false if deal.legal_state_date.nil?
  return false if deal.legal_state_date < Date.parse('01-01-2020')
  true
end

def set_credit_entity(entity)
  return "" if entity.nil?
  return "BANCOLOMBIA" if entity == "BANCOLOMBIA"
  return "DAVIVIENDA" if ["DAVIVIENDA", "DAVIVINDA", "DAVVIENDA"].include? entity
  return "F.N.A." if ["F.N.A", "F.N.A.", "FNA"].include? entity
  return "VENTA DIRECTA" if ["VENTA DIRECTA", "VTA DIRECTA"].include? entity
  return "OTROS" if ["OTROS"].include? entity
end

def set_subsidy_entity(ent1, ent2)
  return "SIN SUBSIDIO" if ent1.nil?
  return "MCY" if ent1 == "MCY"
  return "SUBSIDIO CAJA" if ent2.nil?
  return "SUBSIDIO CAJA Y MCY"
end

def set_ls_date(str_date)
  return nil if str_date.nil?

  DateTime.strptime(str_date, "%d/%m/%y").to_date
end

def deal_params(row, legal_state)
  credit_entity = set_credit_entity(row[122])
  subsidy_entity = set_subsidy_entity(row[126], row[133])

  { ecid: row[4],
    legal_state_dinamia: legal_state,
    total_amount: row[109],
    credit_entity: credit_entity,
    subsidy_entity: subsidy_entity,
    proyect_name: row[0],
    proyect_stage: row[1],
    proyect_apple: row[2],
    land_plot: row[3],
    mortgage_amount: row[122],
    subsidy_amount: row[125],
    savings_amount: row[123],
    layoffs_amount: row[127],
    initial_fee_amount: row[129],
    clearance_amount: row[130],
    initial_fee_subsidy_amount: row[131],
    second_subsidy_amount: row[132],
    swap_amount: row[134],
    legal_state_date: set_ls_date(row[117]),
    client_name: row[24],
    client_phone: row[29],
    client_phone_two: row[30]
    }
end

CSV.foreach(filepath, csv_options) do |row|
  legal_state = row[112]
  params = deal_params(row, legal_state)
  deal = Deal.new(params)
  # next unless deal.ecid == 25314
  # byebug
  puts "#{deal.ecid} - #{deal.legal_state_dinamia}"
  set_deal_legal_state(deal, legal_state)
  if record_exists?(deal)
    compare_changes(deal, params)
  else
    deal.change_flag = true
    deal.trello_flag = false
    deal.save
    puts "Creando negocio #{deal.ecid} #{deal.legal_state_dinamia}"
  end
end

changed_deals = Deal.select { |d| d.change_flag }
puts "Negocios con cambios: #{changed_deals.count}" if changed_deals.count > 0
puts "No ha habido actualizaciones" if changed_deals.count == 0
