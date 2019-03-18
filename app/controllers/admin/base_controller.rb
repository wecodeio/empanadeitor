class Admin::BaseController < ApplicationController
  http_basic_authenticate_with name: ENV['ID'], password: ENV['KEY']
  layout 'admin_application'
end
