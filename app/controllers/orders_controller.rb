class OrdersController < ApplicationController
    def index
        @places = Place.all
    end

    def newOrder
        @place = Place.find(params[:id])
    end
    
    
end
