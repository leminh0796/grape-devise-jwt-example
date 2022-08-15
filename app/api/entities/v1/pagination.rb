class Entities::V1::Pagination < Entities::V1::Base
  root 'pagination', 'pagination'
  expose :pages, documentation: { type: "Integer", desc: "Total pages." }
  expose :next, documentation: { type: "String", desc: "Next page." }
  expose :prev, documentation: { type: "String", desc: "Previous page" }
  expose :page, documentation: { type: 'Integer', desc: 'Current Page.' }
  expose :count, documentation: { type: 'Integer', desc: 'Count.' }
  expose :offset, documentation: { type: 'Integer', desc: 'Offset.' }
end
