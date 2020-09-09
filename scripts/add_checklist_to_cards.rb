# rails runner scripts/add_checklist_to_cards.rb
def post(deal, retries = 3)
  puts "#{deal.card_tid} - #{deal.ecid}"
  url = "https://api.trello.com/1/cards/5f569b3a4a1c4987a7467157?"
  response = HTTParty.post(url, query: body_params)
  # deal.update(trello_flag: true, change_flag: false, card_tid: response["id"])
rescue => e
  puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
  raise if retries <= 1
  post(retries - 1)
end

def body_params
  {
    'key': "#{ENV['TRELLO_KEY']}",
    'token': "#{ENV['TRELLO_TOKEN']}",
    'labels': "Compromisos",
  }
end

deals = Deal.where(trello_flag: true)
deals.each do |deal|
  post(deal)
end

