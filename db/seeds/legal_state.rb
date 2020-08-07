Deal.destroy_all
LegalState.destroy_all

legal_states = [
                { name: "A DESISTIR", board_tid: ""},
                { name: "A REUBICAR", board_tid: ""},
                { name: "ACLARATORIA AL SUBSIDIO", board_tid: ""},
                { name: "APROBADO ", board_tid: ""},
                { name: "AVALUO FINAL", board_tid: "5f1ef0101d91da3d6fb414dc", grouped: true},
                { name: "AVALUO PRELIMINAR", board_tid: "5f1ef0101d91da3d6fb414dc", grouped: true},
                { name: "CARTA DE NOVEDAD", board_tid: ""},
                { name: "CARTA DE RATIFICACION ", board_tid: ""},
                { name: "CASO INMOBILIARIA", board_tid: ""},
                { name: "DESEMBOLSADO", board_tid: ""},
                { name: "ELAB ESCRITURACION", board_tid: "5f1ef05b5cd4c8412a10ab88"},
                { name: "EN ESPERA DE RESOLUCION MCY (PROCESO 027)", board_tid: ""},
                { name: "ENTRADA DE REGISTRO", board_tid: "5f1ef06ed5c05923805fbda4", grouped: true},
                { name: "ENTREGA DE VIVIENDA", board_tid: ""},
                { name: "ESTUDIO TITULO (PROCESO 027)", board_tid: ""},
                { name: "FIRMA BANCO", board_tid: "5f1857980fbd968e3cff4b08", grouped: true},
                { name: "FIRMA BANCO CONSTRUCTOR", board_tid: "5f1857980fbd968e3cff4b08", grouped: true},
                { name: "FIRMA ESC. CLIENTE", board_tid: "5f1857980fbd968e3cff4b08", grouped: true},
                { name: "FIRMA FIDUCIA", board_tid: "5f1857980fbd968e3cff4b08", grouped: true},
                { name: "LIBRE", board_tid: ""},
                { name: "LIBRE INVERSION", board_tid: ""},
                { name: "LIQUIDACION", board_tid: ""},
                { name: "NEGADO", board_tid: ""},
                { name: "PREAPROB Y CONSEC", board_tid: ""},
                { name: "PROTOCOLIZACION", board_tid: "5f1ef15e8abfd186d989fcd2"},
                { name: "RADICADO EN ESPERA DE DESEMBOLSO", board_tid: ""},
                { name: "REVISION FIDUCIA", board_tid: ""},
                { name: "SALDO EN EFECTIVO", board_tid: ""},
                { name: "SALIDA DE REGISTRO", board_tid: "5f1ef06ed5c05923805fbda4", grouped: true},
                { name: "SUBSIDIO RADICADO", board_tid: ""},
                { name: "TRAMITE", board_tid: ""},
                { name: "TRAMITE - ACTUALIZACION", board_tid: ""},
                { name: "FIRMA ESC. CONSTRUCTORA", board_tid: "5f1857980fbd968e3cff4b08"},
                { name: "VENDIDA", board_tid: ""}
              ]

def get_board_list(ls, retries = 3)
  url = "https://api.trello.com/1/boards/#{ls[:board_tid]}/lists?key=#{ENV['TRELLO_KEY']}&token=#{ENV['TRELLO_TOKEN']}"
  response = HTTParty.get(url)
  res = JSON.parse(response.body)

  if ls[:grouped]
    return res.select { |board_list| board_list["name"] == ls[:name] }.first["id"]
  end
  return res.first["id"]

rescue => e
  puts "TRY #{retries}/n ERROR: timed out while trying to connect #{e}"
  raise if retries <= 1
  get_board_list(ls, retries - 1)
end

legal_states.each do |ls|
  list_id = get_board_list(ls) if !ls[:board_tid].empty?
  puts "Creando #{ls[:name]} - Board Tid: #{ls[:board_tid]}"
  legal_state = LegalState.new(name: ls[:name], board_tid: ls[:board_tid], list_tid: list_id)
  legal_state.save
end

puts "Done"




