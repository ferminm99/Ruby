# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

# Proyecto Rails

Este documento resume los pasos principales para configurar y desarrollar el proyecto Rails, incluyendo la configuración de Devise, la creación de un modelo de usuario con un campo adicional, y la implementación de un sistema básico de ABM (Alta, Baja y Modificación) para el manejo de links.

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

### Explicacion de cada parte

## Gestion de usuarios

Se te permite crear cuenta, loguear o desloguear, cancelarla dentro del home y tenes los links en el home

## Home

Aca podes ver tus links, crearlos, editarlos, borrarlos y acceder

## Crear/Editar link

Tenes los tipos de links con sus distintas funcionalidades, el normal, el privado que se accede con contraseña, el efimero que se usa una vez y el temporal que se marca una fecha

## Reportes

Aca se observan

```bash

```
