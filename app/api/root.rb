require 'grape-swagger'
require 'grape_logging'

class Root < Grape::API
  prefix 'api'
  format :json

  logger.formatter = GrapeLogging::Formatters::Default.new
  logger_options = [GrapeLogging::Loggers::FilterParameters.new]
  unless Rails.env.production?
    logger_options << GrapeLogging::Loggers::Response.new
    logger_options << GrapeLogging::Loggers::RequestHeaders.new
  end
  use GrapeLogging::Middleware::RequestLogger, { logger:, include: logger_options }

  mount V1::Base
end
