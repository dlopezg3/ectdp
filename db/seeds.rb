# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Deal.destroy_all
LegalState.destroy_all

legal_states = [
                { name: "A DESISTIR", board_id: ""},
                { name: "A REUBICAR", board_id: ""},
                { name: "ACLARATORIA AL SUBSIDIO", board_id: ""},
                { name: "APROBADO ", board_id: ""},
                { name: "AVALUO", board_id: "5f1ef0101d91da3d6fb414dc"},
                { name: "CARTA DE NOVEDAD", board_id: ""},
                { name: "CARTA DE RATIFICACION ", board_id: ""},
                { name: "CASO INMOBILIARIA", board_id: ""},
                { name: "DESEMBOLSADO", board_id: ""},
                { name: "ELAB ESCRITURACION", board_id: "5f1ef1336e111a794aff7838"},
                { name: "EN ESPERA DE RESOLUCION MCY (PROCESO 027)", board_id: ""},
                { name: "REGISTRO", board_id: "5f1ef06ed5c05923805fbda4"},
                { name: "ENTREGA DE VIVIENDA", board_id: ""},
                { name: "ESTUDIO TITULO (PROCESO 027)", board_id: ""},
                { name: "FIRMA", board_id: "5f1857980fbd968e3cff4b08"},
                { name: "LIBRE", board_id: ""},
                { name: "LIBRE INVERSION", board_id: ""},
                { name: "LIQUIDACION", board_id: ""},
                { name: "NEGADO", board_id: ""},
                { name: "PREAPROB Y CONSEC", board_id: ""},
                { name: "PROTOCOLIZACION", board_id: "5f1ef15e8abfd186d989fcd2"},
                { name: "RADICADO EN ESPERA DE DESEMBOLSO", board_id: ""},
                { name: "REVISION FIDUCIA", board_id: ""},
                { name: "SALDO EN EFECTIVO", board_id: ""},
                { name: "SUBSIDIO RADICADO", board_id: ""},
                { name: "TRAMITE", board_id: ""},
                { name: "VENDIDA", board_id: ""},
                { name: "PRED Y VALOR", board_id: ""}
              ]

legal_states.each do |ls|
  legal_state = LegalState.new(name: ls[:name])
  legal_state.save
end



