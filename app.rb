# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sqlite3'
require 'securerandom'
require 'mail'

require './models/user'
require './models/question'
require './models/answer'
require_relative 'controllers/main_controller'
require_relative 'controllers/users_controller'
require_relative 'controllers/auth_controller'
require_relative 'controllers/game_controller'
require_relative 'controllers/question_controller'

# App: Main application class
#
# Esta clase es el punto de entrada principal para la aplicación.
# Gestiona la configuración general, inicializa las rutas, y controla el flujo
# de solicitudes y respuestas de la aplicación.
#
# Responsabilidades:
# - Configurar las dependencias necesarias para la aplicación.
# - Definir las rutas y controlar el manejo de solicitudes HTTP.
# - Iniciar cualquier configuración global, como la conexión a la base de datos o la carga de variables de entorno.
# - Ejecutar middleware o configurar autenticación, si es necesario.
class App < Sinatra::Application
  use MainController
  use UsersController
  use AuthController
  use GameController
  use QuestionController
  set :database_file, './config/database.yml'
  set :public_folder, 'public'
  set :views, './views'

  def initialize(_app = nil)
    super()
  end

  configure do
    enable :sessions
  end

  before '/questions' do
    session[:processed_questions] ||= []
  end

  # Restricts paths not allowed to get if not logged in
  before do
    public_paths = %w[/login /register / /failed /password_resets/new /password_resets /password_resets/notice]

    public_path_patterns = [
      %r{^/password_resets/\w{22}/edit$},
      %r{^/password_resets/\w{22}$}
    ]

    if public_paths.include?(request.path_info) || public_path_patterns.any? do |pattern|
      request.path_info.match(pattern)
    end
      pass
    else
      redirect '/login' unless session[:username]
    end
  end
end
