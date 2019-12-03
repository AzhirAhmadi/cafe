# User.create(email: "azhir@master.com",password: "123456",role:"sys_master")
# User.create(email: "azhir@admin.com",password: "123456",role:"sys_admin")
# User.create(email: "azhir@expert.com",password: "123456",role:"sys_expert")
# User.create(email: "azhir@coffee_owner.com",password: "123456",role:"coffee_owner")
# User.create(email: "azhir@player.com",password: "123456",role:"player")

# CoffeeShop.create(name: "name123", address: "Address",
#     owner_id: User.coffee_owner.last.id,
#     maintainer_id: User.sys_expert.last.id,
#     creator_id: User.sys_admin.last.id)

# FactoryBot.create :opened_event, coffee_shop: CoffeeShop.find(2)
# FactoryBot.create :opened_event, coffee_shop: CoffeeShop.find(2)
# FactoryBot.create :opened_event, coffee_shop: CoffeeShop.find(2)
# FactoryBot.create :opened_event, coffee_shop: CoffeeShop.find(2)
# FactoryBot.create :opened_event, coffee_shop: CoffeeShop.find(2)

# coffee_shop =  FactoryBot.create :coffee_shop
# opened_event = FactoryBot.create :opened_event, coffee_shop: coffee_shop

# boardgame1 = FactoryBot.create :board_game, coffee_shop: coffee_shop
# boardgame2 = FactoryBot.create :board_game, coffee_shop: coffee_shop
# boardgame3 = FactoryBot.create :board_game, coffee_shop: coffee_shop
# boardgame4 = FactoryBot.create :board_game, coffee_shop: coffee_shop
# boardgame5 = FactoryBot.create :board_game, coffee_shop: coffee_shop

# FactoryBot.create :table, event: opened_event, board_game: boardgame1
# FactoryBot.create :table, event: opened_event, board_game: boardgame2
# FactoryBot.create :table, event: opened_event, board_game: boardgame3
# FactoryBot.create :table, event: opened_event, board_game: boardgame4
# FactoryBot.create :table, event: opened_event, board_game: boardgame5
# coffee_shop = CoffeeShop.find(7)

# FactoryBot.create :locked_event, coffee_shop: coffee_shop
# FactoryBot.create :opened_event, coffee_shop: coffee_shop
# FactoryBot.create :enroled_event, coffee_shop: coffee_shop
# FactoryBot.create :started_event, coffee_shop: coffee_shop
# FactoryBot.create :ended_event, coffee_shop: coffee_shop
# FactoryBot.create :closed_event, coffee_shop: coffee_shop