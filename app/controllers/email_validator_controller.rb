# frozen_string_literal: true

class EmailValidatorController < ApplicationController
  def validate
    result = EmailAuthenticationService.new(params['email_address'], params['headers']).process

    ActionCable.server.broadcast "data_channel", { result: result }
  end
end
