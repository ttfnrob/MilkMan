db_config = YAML::load(File.read(Rails.root.to_s + "/config/mongo.yml"))
 
if db_config[Rails.env] && 
db_config[Rails.env]['adapter'] == 'mongodb'
  mongo = db_config[Rails.env]
  MongoMapper.connection = Mongo::Connection.new(mongo['localhost'])
  MongoMapper.database = mongo['database']
end