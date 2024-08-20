class SettingsController < ApplicationController
  layout 'dashboard'

  def referal 
    render :template => "settings/referal/index"
  end

  def account
    render :template => "settings/account/index"
  end

  def integration
    render :template => "settings/integrations/index"
  end


  def subscription
    render :template => "settings/subscription/index"
  end
end
