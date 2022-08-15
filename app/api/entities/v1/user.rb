class Entities::V1::User < Entities::V1::Base
  root 'data', 'object'
  expose :id, documentation: { type: 'Integer', desc: 'Id of user.' }
  expose :email, documentation: { type: 'String', desc: 'Email of user.' } do |object, options|
    options[:hide_email] ? '' : object.email
  end
end
