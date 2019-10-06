# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# enum role: [:sys_master, :sys_admin, :sys_expert, :cafe_ower,:player]
User.create(email: "azhir@master.com",password: "123456",role:"sys_master")
User.create(email: "azhir@admin.com",password: "123456",role:"sys_admin")
User.create(email: "azhir@expert.com",password: "123456",role:"sys_expert")
User.create(email: "azhir@cafe_ower.com",password: "123456",role:"cafe_ower")
User.create(email: "azhir@player.com",password: "123456",role:"player")
