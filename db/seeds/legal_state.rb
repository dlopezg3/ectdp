# Deal.destroy_all
# LegalStateDuration.destroy_all
# LegalState.destroy_all

legal_states = [
                { name: "A DESISTIR", board_tid: "5f36fec6e8daef3469ac1b1a", list_id:"5f36fef3caacef66835581f6"},
                { name: "A REUBICAR", board_tid: "5f36fec6e8daef3469ac1b1a", list_id:"5f36fec6e8daef3469ac1b1c"},
                { name: "ACLARATORIA AL SUBSIDIO", board_tid: "5f371c7f7df57a1f050ba0fb", list_id:"5f371c7f7df57a1f050ba0ff"},
                { name: "APROBADO", board_tid: "5f36fd2572173a014e3bc186", list_id:"5f36fd2572173a014e3bc187"},
                { name: "APROBADO DAVIVIENDA", board_tid: "5f3ed40f91c99e492decaa6d", list_id:"5f4ff1dd7c37068bf74f48e7"},
                { name: "AVALUO FINAL", board_tid: "5f36fd2572173a014e3bc186", list_id:"5f36fd2572173a014e3bc189"},
                { name: "AVALUO PRELIMINAR", board_tid: "5f3ed40f91c99e492decaa6d", list_id:"5f3ed40f91c99e492decaa6f"},
                { name: "AVALÚO DAVIVIENDA", board_tid: "5f3ed40f91c99e492decaa6d", list_id:"5f4ff1dd7c37068bf74f48e7"},
                { name: "CARTA DE NOVEDAD", board_tid: "5f36fda6193f8676acdd47cd", list_id:"5f36fda6193f8676acdd47ce"},
                { name: "CARTA DE RATIFICACION ", board_tid: "5f36fde4c9024a470fc8934c", list_id:"5f36fde4c9024a470fc8934d"},
                { name: "CASO INMOBILIARIA", board_tid: "5f36fec6e8daef3469ac1b1a", list_id:"5f36fec6e8daef3469ac1b1a"},
                { name: "DESEMBOLSADO", board_tid: "5f371c7f7df57a1f050ba0fb", list_id:"5f371c7f7df57a1f050ba0fc"},
                { name: "ELAB ESCRITURACION", board_tid: "5f1857980fbd968e3cff4b08", list_id:"5f37046a22ad1929d4cdef32"},
                { name: "EN ESPERA DE RESOLUCION MCY (PROCESO 027)", board_tid: "5f331857625722083bc5d3ea", list_id:"5f33185f9c44d701e6dd9512"},
                { name: "ENTRADA DE REGISTRO", board_tid: "5f371cebf6497f5db4b73b5f", list_id:"5f371cebf6497f5db4b73b60"},
                { name: "ENTREGA DE VIVIENDA", board_tid: "5f37006b39980f8c9b4e4aef", list_id:"5f37006b39980f8c9b4e4af0"},
                { name: "ESTUDIO TITULOS", board_tid: "5f43d43591733784b29ee9f5", list_id:"5f43d43591733784b29ee9f6"},
                { name: "FIRMA BANCO", board_tid: "5f1857980fbd968e3cff4b08", list_id:"5f3323621a31a917b171c251"},
                { name: "FIRMA BANCO CONSTRUCTOR", board_tid: "5f441c8a681cf72a03d15258", list_id:"5f441c8a681cf72a03d15259"},
                { name: "FIRMA ESC. CLIENTE", board_tid: "5f1857980fbd968e3cff4b08", list_id:"5f185c45782e168d081a7a30"},
                { name: "FIRMA FIDUCIA", board_tid: "5f1857980fbd968e3cff4b08", list_id:"5f1eef9fdfaa3d2441228a85"},
                { name: "LIBRE", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id:""},
                { name: "LIBRE INVERSION", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id:"5f1ef05b5cd4c8412a10ab8c"},
                { name: "LIQUIDACION", board_tid: "5f1ef15e8abfd186d989fcd2", list_id:"5f1ef15e8abfd186d989fcd4"},
                { name: "NEGADO", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id:"5f36fc940b177b2ba3c7726c"},
                { name: "PREAPROB Y CONSEC", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id:"5f1ef05b5cd4c8412a10ab8b"},
                { name: "PROTOCOLIZACION", board_tid: "5f1ef15e8abfd186d989fcd2", list_id:"5f1ef15e8abfd186d989fcd3"},
                { name: "RADICADO EN ESPERA DE DESEMBOLSO", board_tid: "5f4515264ee3ff29e57acdf4", list_id:"5f4515264ee3ff29e57acdf5"},
                { name: "REVISION FIDUCIA", board_tid: "5f1857980fbd968e3cff4b08", list_id:"5f3700a6a30f89266302ebb6"},
                { name: "SALDO EN EFECTIVO", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id:"5f2accfee570290e693af3f8"},
                { name: "ESCRITURA EN REGISTRO", board_tid: "5f371cebf6497f5db4b73b5f", list_id:"5f371cebf6497f5db4b73b60"},
                { name: "SUBSIDIO RADICADO", board_tid: "5f371c7f7df57a1f050ba0fb", list_id:"5f371c7f7df57a1f050ba0fd"},
                { name: "TRAMITE", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id:"5f36fbc63a1e538518df12a3"},
                { name: "TRAMITE - ACTUALIZACION", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id:"5f36fc909abba8143fd9a207"},
                { name: "FIRMA ESC. CONSTRUCTORA", board_tid: "5f1857980fbd968e3cff4b08", list_id:"5f2d7b023f782403bb6b0ab2"},
                { name: "VENDIDA", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id:"5f57f1493d322a1ae2c672e3"},
                { name: "RADICADO EN BANCO Y CAJA", board_tid: "5f331cd2aa36eb25e0ba2327", list_id:"5f331cdc0aee5a416f58ed9a"},
                { name: "EN ESPERA RESOLUCION MCY PARA ESTUDIO TITULO", board_tid: "5f3ecabe6a9adb3d1376cbce", list_id:"5f3ecabe6a9adb3d1376cbcf"},
                { name: "NUMERACION ESCRITURA", board_tid: "5f1857980fbd968e3cff4b08", list_id:"5f4059d675d279624c0a34bf"},
                { name: "TRAMITE BANCO 1", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id: "5f36fbc63a1e538518df12a3"},
                { name: "TRAMITE BANCO 2", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id: "5f593a6df38a3d6115668d29"},
                { name: "TRAMITE BANCO 3", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id: "5f593a777697cd366ab49fe6"},
                { name: "TRAMITE DATACREDITO", board_tid: "5f1ef05b5cd4c8412a10ab88", list_id: "5f5a77360643a12c81ffa00d"},
                { name: "VENDIDA INCONVENIENTES", board_tid: "5f36fec6e8daef3469ac1b1a", list_id: "5f5a7bf8420b6163404e84f3"},
              ]

legal_states.each do |ls|
  list_id = ls[:list_id]
  if LegalState.find_by(name: ls[:name]).nil?
    puts "Creando #{ls[:name]} - Board Tid: #{ls[:board_tid]}"
    legal_state = LegalState.new(name: ls[:name], board_tid: ls[:board_tid], list_tid: list_id)
    legal_state.save
  end
end

puts "Done"




