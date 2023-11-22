class EmailConstraint
  def self.matches?(request)
    request.env['warden'].authenticate? && request.env['warden'].user.email == 'flstudio444@gmail.com'
  end
end