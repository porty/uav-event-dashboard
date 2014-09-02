class BasicAuthController < ApplicationController
   http_basic_authenticate_with name: 'uav', password: 'joe'
end
