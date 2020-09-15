# seeds para popular los custom fields de los tableros en base de datos

CustomField.destroy_all

def get_board_custom_fields(ls, retries = 3)
  url = "https://api.trello.com/1/boards/#{ls.board_tid}/customFields?key=#{ENV['TRELLO_KEY']}&token=#{ENV['TRELLO_TOKEN']}"
  response = HTTParty.get(url)
  res = JSON.parse(response.body)
  puts "Comenzando con #{ls.name}"
  res.each do |custom_field|
    create_custom_field_on_legal_state(ls, custom_field)
  end
  puts "------------------"
rescue Net::ReadTimeout => e
  puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
  raise e if retries <= 1
  get_board_labels(ls, retries - 1)
rescue JSON::ParserError => e
  abort "OJO ------------------- la url tiene una falla"
end

def create_custom_field_on_legal_state(ls, custom_field)
  puts "Creando custom_field #{custom_field["name"]} en: #{ls.name}"
  args = {name: custom_field["name"], legal_state_id: ls.id, tid: custom_field["id"] }
  CustomField.create!(args)
end

LegalState.all.each do |ls|
  get_board_custom_fields(ls) unless ls.board_tid.empty?
end
