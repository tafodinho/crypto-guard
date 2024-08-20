module ApplicationHelper
  def hyphenate_string(str)
    str.gsub(/\s+/, '-')
  end

  def format_large_number(number)
    if number >= 1_000_000_000
      "#{(number / 1_000_000_000.0).round(2)}B"
    elsif number >= 1_000_000
      "#{(number / 1_000_000.0).round(2)}M"
    elsif number >= 1_000
      "#{(number / 1_000.0).round(2)}K"
    else
      number.to_s
    end
  end

  def current_plan
    current_user.custom_attributes['plan_name']
  end

  def subscription_status 
    current_user.custom_attributes['subscription_status']
  end
end
