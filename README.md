# Carga de Negocios de Enfoque Constructores En Trello

_Herramienta diseñada para cargar los negocios de Enfoque Constructores como tarjetas de trello
para tener un mejor seguimiento de los estados legales en los que se encuentran cada uno de
esos negocios_

## Comenzando 🚀

Para comenzar se debe hacer un seed de las tablas de legal_states, labels y legal_state_duration

Esto se hace con los siguientes comandos:

```
  rails db:seed:legal_state
  rails db:seed:labels
  rails db:seed:legal_state_duration
```

## Primera carga de negocios en base de datos 🛫

Para realizar la carga de negocios en base de datos local se debe:

 1. En la carpeta app/data/deals_files agregar el informe de estados legales en formato .csv con el nombre: INFORME_DE_ESTADOS_LEGALES.csv
 2. Ejecutar el siguiente comando:

```
  rails r scripts/deals_migration.rb
```

Este script carga todos los nuevos negocios del informe (en caso de no tener otros guardados con aterioridad) en base de datos.

## Actualización de negocios en base de datos  🎢

 1. En la carpeta app/data/deals_files reemplazar el informe de estados legales en formato .csv con el mismo nombre
 2. Ejecutar el mismo comando:

```
  rails r scripts/deals_migration.rb
```

Este script revisa cada negocio y si encuentra algún cambio en los atributos lo actualiza.
En caso de encontrar un registro nuevo lo agrega en base de datos.

## Carga de tarjetas en Trello ⬆️

* ir la url a #{host}/deals

Esto crea las nuevas tarjetas en caso de haber.
Solo actualiza según los scopes configurados en el modelo Deal

## Añadir una nueva etiqueta en los tableros 🎗

  1. Se debe crear la etiqueta en todos los tableros (esto se puede hacer pasando una tarjeta con la etiqueta por todos los tableros)
  2. Se ejecuta el siguiente comando en terminal:
   ```
    rails db:seed:labels
   ```
  3. Se ejecuta el script de migración de etiquetas:
   ```
    rails runner scripts/add_project_labels_to_cards.rb
   ```




## Construido con 🛠️

* Ruby on Rails 6 - El framework web usado
* Bundler - Manejador de dependencias


---
⌨️ con ❤️ por Daniel López(https://github.com/dlopezg3) 🚴🏼‍♂️
