require 'pry'

class Application
  
    def call(env)
      resp = Rack::Response.new
      req = Rack::Request.new(env)
  
      if req.path.match(/items/)
        item_name = req.path.split("/items/").last
        item = Item.all.find{|i| i.name == item_name}

        if item != nil
            resp.write "#{item.name} - #{item.price}" 
        else
            resp.status = 400
            resp.write "Item not found"
        end
          
  
      elsif req.path.match(/search/)
        search_term = req.params["q"]
        resp.write handle_search(search_term)
  
      elsif req.path.match(/cart/)
        if Item.all[0] != nil
            Item.all.each do |item|
            resp.write "#{item}\n"
          end
        else
          resp.write "Your cart is empty"
        end
  
      elsif req.path.match(/add/)
        item = req.params["item"]
        if Item.all.include?(item)
            Item.all << item
          resp.write "added #{item}"
          

        else
            resp.status = 400
          resp.write "We don't have that item"
        end
      else
        resp.status = 404
        resp.write "Route not found"
      
      end
      resp.finish
      
    end
  
    def handle_search(search_term)
      if Item.all.include?(search_term)
        return "#{search_term} is one of our items"
      else
        return "Couldn't find #{search_term}"
      end
    end
  
  end
  