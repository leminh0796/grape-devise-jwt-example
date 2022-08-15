class AccountService
  def initialize(params, flow = 'user')
    @params = params
    @flow = flow
  end

  def create_new_account
    User.create @params if @flow == 'user'
  end
end
