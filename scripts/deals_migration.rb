# rails runner scripts/deals_migration.rb
require 'csv'
require_relative 'ls_equivalents'

csv_options = { col_sep: ';', force_quotes: true, quote_char: '"', headers: true}
filepath = 'app/data/deals_files/INFORME_DE_ESTADOS_LEGALES.csv'
# count = 0

def record_exists?(deal)
  !Deal.find_by(ecid: deal[:ecid]).nil?
end

def compare_changes(deal, params)
  original_deal = Deal.find_by(ecid: deal[:ecid])
  if deal.diff?(original_deal)
    original_deal.update(params)
    original_deal.update(change_flag: true)
    puts "Actualizando negocio #{deal.ecid}"
  else
    original_deal.update(change_flag: false)
  end
end

def set_deal_legal_state(deal, legal_state)
  # byebug if deal.ecid == 41926
  legal_trello_state = LS_EQUIVALENTS[legal_state.to_sym]
  deal.legal_state = LegalState.find_by(name: legal_trello_state)
  deal
end

CSV.foreach(filepath, csv_options) do |row|
  # break if count > 3000
  legal_state = row[112]
  params = {ecid: row[4],
            legal_state_dinamia: legal_state,
            total_amount: row[109],
            credit_entity: row[122],
            subsidy_entity: row[126],
            proyect_name: row[0],
            proyect_stage: row[1],
            proyect_apple: row[2],
            land_plot: row[3],
            mortgage_amount: row[122],
            subsidy_amount: row[125]}
  deal = Deal.new(params)
  set_deal_legal_state(deal, legal_state)
  if record_exists?(deal)
    compare_changes(deal, params)
  else
    deal.change_flag = true
    deal.trello_flag = false
    deal.save
    puts "Creando negocio #{deal.ecid}"
  end
  # count += 1
end

changed_deals = Deal.select { |d| d.change_flag }
puts "Negocios con cambios: #{changed_deals.count}" if changed_deals.count > 0
puts "No ha habido actualizaciones" if changed_deals.count == 0
# changed_deals.each {|d| puts d.ecid }












