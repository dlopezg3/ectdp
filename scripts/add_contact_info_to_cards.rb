# rails runner scripts/add_contact_info_to_cards.rb
def post(deal, retries = 3)
  valids = ["Teléfono 1","Teléfono 2", "Cliente"]
  deal.legal_state.custom_fields.each do |cf|
    puts cf.name
    next unless valids.include? cf.name
    puts "#{deal.card_tid} - #{deal.ecid} -  #{cf.name}"
    url = "https://api.trello.com/1/cards/#{deal.card_tid}/customField/#{cf.tid}/item?"
    response = HTTParty.put(url, body: body_params(cf, deal),  query: query_params)
  end
rescue Net::ReadTimeout => e
  puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
  raise if retries <= 1
  post(retries - 1)
rescue Net::OpenTimeout => e
  puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
  raise if retries <= 1
  post(retries - 1)
end

def query_params
  {
    'key': "#{ENV['TRELLO_KEY']}",
    'token': "#{ENV['TRELLO_TOKEN']}"
  }
end

def body_params(cf, deal)
  {
    value: {
      text: "#{set_custom_field_value(cf, deal)}"
    }
  }
end

def set_custom_field_value(cf, deal)
  cf_name = cf.name
  return deal.client_phone     if cf_name == "Teléfono 1"
  return deal.client_name      if cf_name == "Cliente"
  return deal.client_phone_two if cf_name == "Teléfono 2"
end

deals = Deal.where(trello_flag: true)
deals.each do |deal|
  post(deal)
end

