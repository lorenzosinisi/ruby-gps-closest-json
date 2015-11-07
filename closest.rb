# Require or install kdtree library for ruby
# source of the library https://github.com/gurgeous/kdtree
begin
  require 'kdtree'
rescue LoadError => e
  puts "exception: Kdtree not present in this machine, installing Kdtree gem ..."
  h = system 'gem install kdtree'
  puts "gem installed #{h}"
  Gem.clear_paths
  require 'kdtree'
end

# require json or install the gem
begin 
  require 'json'
rescue LoadError => e
  puts "exception: json not present in this machine, installing json gem ..."
  h = system 'gem install json'
  puts "gem installed #{h}"
  Gem.clear_paths
  require 'json'
end

# GENERATE treefile in case doen't not exist and avoid generating it again every time
# The idea is that the file can be deleted in order to add new nodes and new points

unless File.exist?("treefile")
  
  # parse the json that in our case looks like:
  # 
  # {
  #   "success": true,
  #   "head": {
  #     "action": "locations"
  #     },
  #     "locations": [
  #     {
  #       "vehicleCount": "1",
  #       "latitude": "51.511318",
  #       "restrictedP": "f",
  #       "description": "West Ealing - Hartington Rd",
  #       "marketId": "33074166",
  #       "locationId": "549202705",
  #       "hasVans": "1",
  #       "longitude": "-.318178",
  #       "zipfleetId": "33074050"
  #     },
  #     etc..
  #

  data = JSON.parse( File.read('data.json') )
  points = []

  # when the json is fine and contains locations, proceed generating the points of the tree
  if data['success'] and data['head']['action'] == "locations"
    data['locations'].each do |key|
      points << [ key['latitude'].to_f, key['longitude'].to_f, key['locationId'].to_i]
    end
  end

  # Create a new tree and store it in treefile
  tree = Kdtree.new(points)
  File.open("treefile", "w") { |f| tree.persist(f) }

end

# normally would be used like this:

kd2 = File.open("treefile") { |f| Kdtree.new(f) }
p kd2.nearest(51.559712, -0.249054) # => locationId: 549204681

