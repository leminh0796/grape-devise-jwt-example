# Handle exceptions
module V1::ExceptionsHandler
  extend ActiveSupport::Concern

  included do
    rescue_from :all do |e|
      status, message =
        case e
        when ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
          [422, e.record.errors.full_messages.join(', ')]
        when RecordNotConfirm
          [422, e.message]
        when ApplicationError
          [400, e.message]
        when ActiveRecord::RecordNotFound, PageEmpty
          [404, e.message]
        when Grape::Exceptions::ValidationErrors
          [406, e.message]
        when MethodNotAllowed
          [405, e.message]
        else
          [500, e.message]
        end

      logger.error e

      error!({ error: message, status: }, status)
    end
  end
end

class ApplicationError < StandardError; end

class RecordNotConfirm < StandardError; end

class PageEmpty < StandardError; end

class MethodNotAllowed < StandardError; end
