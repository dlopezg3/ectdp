# seeds para popular las etiquetas de los tableros en base de datos

BankLabel.destroy_all
SubsidyLabel.destroy_all
# ProjectLabel.destroy_all
ProjectStageLabel.destroy_all

def get_board_labels(ls, retries = 3)
  url = "https://api.trello.com/1/boards/#{ls.board_tid}/labels?key=#{ENV['TRELLO_KEY']}&token=#{ENV['TRELLO_TOKEN']}"
  response = HTTParty.get(url)
  res = JSON.parse(response.body)
  puts "Comenzando con #{ls.name}"
  res.each do |label|
    create_label_on_legal_state(ls, label) unless label["name"].empty?
  end
  puts "------------------"
rescue Net::ReadTimeout => e
  puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
  raise e if retries <= 1
  get_board_labels(ls, retries - 1)
end

def create_label_on_legal_state(ls, label)
  puts "Creando Label #{label["name"]} en: #{ls.name}"
  args = {name: label["name"], legal_state_id: ls.id, tid: label["id"] }
  if credit_label?(label)
    BankLabel.create!(args)
  elsif subsidy_label?(label)
    SubsidyLabel.create!(args)
  # elsif project_label?(label)
    # ProjectLabel.create!(args)
  elsif project_stage_label?(label)
    ProjectStageLabel.create!(args)
  end
end

def credit_label?(label)
  credit_entities = [ "DAVIVIENDA", "BANCOLOMBIA", "OTROS", "F.N.A.", "VENTA DIRECTA" ]
  return true if credit_entities.include? label["name"]
  return false
end

def subsidy_label?(label)
  subsidy_label = [ "SUBSIDIO CAJA", "MCY", "SUBSIDIO CAJA Y MCY", "SIN SUBSIDIO" ]
  return true if subsidy_label.include? label["name"]
  return false
end

# def project_label?(label)
#   project_label = [ "ORO BLANCO", "URBANIZACION ALTOS DE PLAN PAREJO II", "KARAKOLI", "ARBOLEDA",
#                   "SANDALO", "CIUDADELA ALTOS DE LOS LAURELES URBANIZACIÓN LAS ACACIAS VIS",
#                   "URBANIZACIÓN PIAMONTE", "PALO ALTO ", "PALO ALTO 2", "MIRADOR DE PLAN PAREJO",
#                   "SAN ANGEL", "MANDALA", "VILLAGRANDE DE INDIAS II ", "LA PRIMAVERA 2" ]

#   return true if project_label.include? label["name"]
#   return false
# end

def project_stage_label?(label)
  project_stage_label =  [ "ORO BLANCO ETAP 1", "ORO BLANCO ETAP 4", "ORO BLANCO-FONVIVIENDA",
                    "APP CASAS", "APP II ETAPA III (117 CASAS)", "KARAKOLI ET 1", "ARBOLEDA ETP 1",
                    "SANDALO ETP  2", "LAS ACACIAS VIS ETP II SUB ETPA II", "LAS ACACIAS VIS  ETP IV",
                    "LAS ACACIAS VIS ETP V", "LAS ACACIAS VIS ETP III", "LAS ACACIAS VIS ETP II SUB ETP I",
                    "PIAMONTE ETAPA 2", "PALO ALTO", "PALO ALTO 2", "PIAMONTE ETAPA 3", "ORO BLANCO ETAP 3",
                    "APP CASAS ETAPA IV", "MIRADOR PP ETP I", "SANDALO ETP 1", "LAS ACACIAS VIS ETP I SUB ETP I",
                    "SAN ANGEL VIS", "ORO BLANCO ETAP 2", "APP CASAS ET III", "MANDALA ETAPA 4", "PIAMONTE ETP 1",
                    "VGI 2 ET VII (56) SUB ETP I", "LAS ACACIAS VIS ETP I SUB ETP III", "LA PRIMAVERA 2 ET 1",
                    "LA PRIMAVERA 2 ET 2", "ARBOLEDA ETP 2", "LAS ACACIAS VIS ETP I SUB ETP II",
                    "VGI 2 ET VII (15) SUB ETP II", "MANDALA ETAPA 1", "MANDALA ETAPA 2", "APP CASAS ET II",
                    "MANDALA ETAPA 3 PROPIO" ]

  return true if project_stage_label.include? label["name"]
  return false
end

LegalState.all.each do |ls|
  get_board_labels(ls) unless ls.board_tid.empty?
end
