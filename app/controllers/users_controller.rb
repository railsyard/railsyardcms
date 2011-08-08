class UsersController < ApplicationController
  # before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show]
  
end
