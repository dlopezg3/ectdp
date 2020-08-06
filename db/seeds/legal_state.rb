# Deal.destroy_all
LegalState.destroy_all

legal_states = [
                { name: "A DESISTIR", board_tid: ""},
                { name: "A REUBICAR", board_tid: ""},
                { name: "ACLARATORIA AL SUBSIDIO", board_tid: ""},
                { name: "APROBADO ", board_tid: ""},
                { name: "AVALUO", board_tid: "5f1ef0101d91da3d6fb414dc"},
                { name: "CARTA DE NOVEDAD", board_tid: ""},
                { name: "CARTA DE RATIFICACION ", board_tid: ""},
                { name: "CASO INMOBILIARIA", board_tid: ""},
                { name: "DESEMBOLSADO", board_tid: ""},
                { name: "ELAB ESCRITURACION", board_tid: "5f1ef05b5cd4c8412a10ab88"},
                { name: "EN ESPERA DE RESOLUCION MCY (PROCESO 027)", board_tid: ""},
                { name: "REGISTRO", board_tid: "5f1ef06ed5c05923805fbda4"},
                { name: "ENTREGA DE VIVIENDA", board_tid: ""},
                { name: "ESTUDIO TITULO (PROCESO 027)", board_tid: ""},
                { name: "FIRMA", board_tid: "5f1857980fbd968e3cff4b08"},
                { name: "LIBRE", board_tid: ""},
                { name: "LIBRE INVERSION", board_tid: ""},
                { name: "LIQUIDACION", board_tid: ""},
                { name: "NEGADO", board_tid: ""},
                { name: "PREAPROB Y CONSEC", board_tid: ""},
                { name: "PROTOCOLIZACION", board_tid: "5f1ef15e8abfd186d989fcd2"},
                { name: "RADICADO EN ESPERA DE DESEMBOLSO", board_tid: ""},
                { name: "REVISION FIDUCIA", board_tid: ""},
                { name: "SALDO EN EFECTIVO", board_tid: ""},
                { name: "SUBSIDIO RADICADO", board_tid: ""},
                { name: "TRAMITE", board_tid: ""},
                { name: "VENDIDA", board_tid: ""},
                { name: "PRED Y VALOR", board_tid: ""}
              ]

def get_board_list(board_tid, retries = 3)
  url = "https://api.trello.com/1/boards/#{board_tid}/lists?key=#{ENV['TRELLO_KEY']}&token=#{ENV['TRELLO_TOKEN']}"
  response = HTTParty.get(url)
  res = JSON.parse(response.body)
  list_id = res.first["id"]
  list_id
rescue Net::OpenTimeout => e
  puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
  if retries <= 1
    raise
  end
  get_board_list(d, retries - 1)
end

legal_states.each do |ls|
  list_id = get_board_list(ls[:board_tid]) if !ls[:board_tid].empty?

  legal_state = LegalState.new(name: ls[:name], board_tid: ls[:board_tid], list_tid: list_id)
  legal_state.save
end
