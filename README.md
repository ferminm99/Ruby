# README

# Proyecto Rails

Este documento resume los pasos principales para configurar y desarrollar el proyecto Rails, incluyendo la configuración de Devise para todo lo relacionado con usuarios, el diseño de los modelos y los menús creados para manejar links y ver reportes.

### Instalación de Rails

gem install rails

## Creación del Proyecto

rails new mi_proyecto_rails
cd mi_proyecto_rails

## Configuración de Devise

gem 'devise'

## Instalar Devise

bundle install
rails generate devise:install

## Creación del Modelo Usuario con Devise

rails generate devise User
rails db:migrate

## Personalización del Modelo Usuario

rails generate migration AddUsernameToUsers username:string:uniq
rails db:migrate
Actualizar Modelo User

## Creación de la Página de Inicio y Rutas

Generador del Controller Home:
rails generate controller Home index
Configuracion de rutas en rails generate controller Home index

## Implementación de ABM para Links

rails generate model Link url:string user:references
rails db:migrate
De la misma forma que se hizo el rails generate migration AddUsernameToUsers username:string:uniq para agregar mas campos a usuario se hizo para link para la fecha de expiracion, slug,etc

## Creacion de reportes

Dentro de links se creo una forma de asociar el ip y fecha con horario y todo al mismo link, que son sus accesos, entonces se hizo el html para poder visualizar esos datos requeridos

## Controlador y Vistas para Link

Controlador y Vistas para Link
Crear acciones en LinksController y vistas correspondientes en app/views/links
Definir rutas en config/routes.rb

## DECISIONES DE DISEÑO

## Modelos y Relaciones

User: Representa a los usuarios de la aplicación. Cada usuario puede tener múltiples enlaces (Link). Se utilizo Devise para la autenticación, lo que añade campos como email y encrypted_password.
Link: Representa un enlace o URL que un usuario puede compartir. Pertenece a un User y tiene muchos LinkAccess. Incluye campos como url, slug, y link_type. Utilizamos un enum para link_type para definir diferentes tipos de enlaces (regular, temporal, privado, efímero).
LinkAccess: Registra cada acceso a un enlace, asociado con un Link. Guarda información como la fecha de acceso y la dirección IP.

## Validaciones en Modelos:

User: Validacion de la presencia y unicidad del username.
Link: Validacion de la presencia de url y slug, slug único. Además, validaciones condicionales para password y expiration_date dependiendo del link_type.
LinkAccess: Validaciones de presencia para link_id y ip_address.

### Explicacion de cada parte a la hora de usarla

## Gestion de usuarios

Se te permite crear cuenta, loguear o desloguear, cancelarla dentro del home y tenes los links en el home

## Home

Aca podes ver tus links en una tabla, crearlos, editarlos, borrarlos y acceder

## Crear/Editar link

Tenes los tipos de links con sus distintas funcionalidades, el normal, el privado que se accede con contraseña, el efimero que se usa una vez y el temporal que se marca una fecha

## Reportes

Aca se observan los accesos a cada link en una tabla con el IP, como tambien otra tabla donde se ven los accesos en cada dia, y hay un filtro para buscar si hay demasiados

```bash

```
