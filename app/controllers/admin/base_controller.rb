# -*- coding: utf-8 -*-
class Admin::BaseController < ApplicationController
#  layout "admin/layouts/admin"
  layout "admin/layouts/application"
  

  #before_filter :authenticate_staff!
  
  #before_action :auth
  
  def auth
    if session[:owner_id].blank?
      render template: "admin/login/new", layout: "admin/layouts/login_layout"
      return false
    end
    
    owner = nil
    if session[:owner_id] == "tripod"
      owner_id = Tpd::AppConfig.value('site_owner_id')
      owner = Tpd::Person::User.find(owner_id)
    else
      owner = Tpd::Person::User.find(session[:owner_id])
    end
    if owner.blank?
      session[:owner_id] = nil
      return false
    end
    return true
  end  

end
