# Module Trackable from Devise, custom for Grape API request

module Trackable
  def self.required_fields(_klass)
    %i[current_sign_in_at current_sign_in_ip last_sign_in_at last_sign_in_ip sign_in_count]
  end

  def update_tracked_fields(request)
    old_current = current_sign_in_at
    new_current = Time.now.utc
    self.last_sign_in_at     = old_current || new_current
    self.current_sign_in_at  = new_current

    old_current = current_sign_in_ip
    new_current = extract_ip_from(request)
    self.last_sign_in_ip     = old_current || new_current
    self.current_sign_in_ip  = new_current

    self.sign_in_count ||= 0
    self.sign_in_count += 1
  end

  def update_tracked_fields!(request)
    # We have to check if the user is already persisted before running
    # `save` here because invalid users can be saved if we don't.
    # See https://github.com/heartcombo/devise/issues/4673 for more details.
    return if new_record?

    update_tracked_fields(request)
    save(validate: false)
  end

  protected

  def extract_ip_from(request)
    return request.ip if request.respond_to? :ip

    return request.remote_ip if request.respond_to? :remote_ip

    ''
  end
end
