# frozen_string_literal: true
module RackFaradayHelper
  def rack_faraday
    Faraday.new { |c| c.adapter :rack, Rails.application }
  end
end
