# seeds para popular las etiquetas de los tableros en base de datos

BankLabel.destroy_all
SubsidyLabel.destroy_all

def get_board_labels(ls, retries = 3)
  puts "Comenzando con #{ls.name}"
  url = "https://api.trello.com/1/boards/#{ls.board_tid}/labels?key=#{ENV['TRELLO_KEY']}&token=#{ENV['TRELLO_TOKEN']}"
  response = HTTParty.get(url)
  res = JSON.parse(response.body)
  res.each do |label|
    create_label_on_legal_state(ls, label) unless label["name"].empty?
  end
  puts "------------------"
rescue => e
  puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
  if retries <= 1
    raise
  end
  get_board_labels(ls, retries - 1)
end

def create_label_on_legal_state(ls, label)
  puts "Creando Label #{label["name"]} en: #{ls.name}"
  if credit_label?(label)
    bl = BankLabel.new(name: label["name"], legal_state_id: ls.id, tid: label["id"] )
    bl.save!
  else
    sl = SubsidyLabel.new(name: label["name"], legal_state_id: ls.id, tid: label["id"] )
    sl.save!
  end
end

def credit_label?(label)
  credit_entities = [ "DAVIVIENDA", "BANCOLOMBIA", "OTROS", "F.N.A.", "VENTA DIRECTA" ]
  return true if credit_entities.include? label["name"]
  return false
end

LegalState.all.each do |ls|
  get_board_labels(ls) unless ls.board_tid.empty?
end


