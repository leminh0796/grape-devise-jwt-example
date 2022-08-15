class V1::Base < Grape::API
  helpers V1::Helpers
  include V1::ExceptionsHandler

  prefix 'api'
  format :json
  version 'v1'

  get :health_check do
    status 200
    extra_infos = { message: 'Ok!' }
    present extra_infos
  end

  mount V1::Users

  add_swagger_documentation \
    api_version: version,
    hide_format: true,
    hide_documentation_path: true,
    doc_version: '0.0.1',
    info: {
      title: "Change Name Later API Documentation",
      description: "A description of the API."
    }
end
