require_relative 'days_table'

LegalStateDuration.destroy_all

INVALIDOS = []
LEGAL_STATES_DAYS_ARRAY.each do |ls_combination|
  lsd = LegalStateDuration.new(credit_entity: ls_combination[:credit_entity],
                               subsidy_entity: ls_combination[:subsidy_entity],
                               days: ls_combination[:days])
  lsd.legal_state = LegalState.find_by(name: ls_combination[:legal_state])
  lsd.save if lsd.valid?
  INVALIDOS << ls_combination[:legal_state] if !lsd.valid?
end
puts "Invalidos"
puts INVALIDOS.uniq



