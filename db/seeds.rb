# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



Database.new.generate_models('develop')
model = Database.get_model('develop', 'order')
model.create({ name: '野比　のび太', phone: '090-1234-5678',  email: 'nobi@nobita.com', address: '東京都 練馬区 月見台1丁目' })
model.create({ name: '出木　杉英才', phone: '090-2345-6789',  email: 'deki@sugihidetoshi.com', address: '東京都 練馬区 月見台2丁目' })
model.create({ name: '骨川　スネ夫', phone: '090-3456-7890',  email: 'honekawa@suneo.com', address: '東京都 練馬区 月見台3丁目' })