require 'rails_helper'

RSpec.describe EnrolmentsController, type: :request do
    describe ".index" do
        context "when loged in az player" do
            it "shloud see enrolment in event which is in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                events = create_list(:opened_event, 2, coffee_shop: coffee_shop)
                board_games = create_list(:board_game, 2, coffee_shop: coffee_shop)

                tables1 = board_games.map { |p| create :table, board_game: p, event: events[0] }
                tables2 = board_games.map { |p| create :table, board_game: p, event: events[1] }

                enrolments1 = create_list(:enrolment, 2, table: tables1[0])
                enrolments2 = create_list(:enrolment, 2, table: tables1[1])
                enrolments3 = create_list(:enrolment, 2, table: tables2[0])
                enrolments4 = create_list(:enrolment, 2, table: tables2[1])

                get coffee_shop_event_table_enrolments_url(coffee_shop, events[0], tables1[0]),
                headers: headers

                expect(json["data"].length).to eql(2)
                expect(json["data"][0]["id"].to_i).to eql(enrolments1[0].id)
                expect(json["data"][0]["attributes"]["table"]["id"].to_i).to eql(tables1[0].id)
            end

            it "shloud not see enrolment in open event which is not in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop
                other_coffee_shop = create :coffee_shop

                events = create_list(:opened_event, 2, coffee_shop: coffee_shop)
                board_games = create_list(:board_game, 2, coffee_shop: coffee_shop)

                tables1 = board_games.map { |p| create :table, board_game: p, event: events[0] }
                tables2 = board_games.map { |p| create :table, board_game: p, event: events[1] }

                enrolments1 = create_list(:enrolment, 2, table: tables1[0])
                enrolments2 = create_list(:enrolment, 2, table: tables1[1])
                enrolments3 = create_list(:enrolment, 2, table: tables2[0])
                enrolments4 = create_list(:enrolment, 2, table: tables2[1])

                get coffee_shop_event_table_enrolments_url(other_coffee_shop, events[0], tables1[0]),
                headers: headers

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see enrolment which is not in open event in coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                events = create_list(:event, 2, coffee_shop: coffee_shop)
                board_games = create_list(:board_game, 2, coffee_shop: coffee_shop)

                tables1 = board_games.map { |p| create :table, board_game: p, event: events[0] }
                tables2 = board_games.map { |p| create :table, board_game: p, event: events[1] }

                enrolments1 = create_list(:enrolment, 2, table: tables1[0])
                enrolments2 = create_list(:enrolment, 2, table: tables1[1])
                enrolments3 = create_list(:enrolment, 2, table: tables2[0])
                enrolments4 = create_list(:enrolment, 2, table: tables2[1])

                get coffee_shop_event_table_enrolments_url(coffee_shop, events[0], tables1[0]),
                headers: headers

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see enrolment in locked event" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                events = create_list(:locked_event , 2, coffee_shop: coffee_shop)
                board_games = create_list(:board_game, 2, coffee_shop: coffee_shop)

                tables1 = board_games.map { |p| create :table, board_game: p, event: events[0] }
                tables2 = board_games.map { |p| create :table, board_game: p, event: events[1] }

                enrolments1 = create_list(:enrolment, 2, table: tables1[0])
                enrolments2 = create_list(:enrolment, 2, table: tables1[1])
                enrolments3 = create_list(:enrolment, 2, table: tables2[0])
                enrolments4 = create_list(:enrolment, 2, table: tables2[1])

                get coffee_shop_event_table_enrolments_url(coffee_shop, events[0], tables1[0]),
                headers: headers

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see deactivated enrolment" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                events = create_list(:opened_event , 2, coffee_shop: coffee_shop)
                board_games = create_list(:board_game, 2, coffee_shop: coffee_shop)

                tables1 = board_games.map { |p| create :table, board_game: p, event: events[0] }
                tables2 = board_games.map { |p| create :table, board_game: p, event: events[1] }

                enrolments1 = create_list(:enrolment, 2, table: tables1[0])
                enrolments2 = create_list(:enrolment, 2, table: tables1[1])
                enrolments3 = create_list(:enrolment, 2, table: tables2[0])
                enrolments4 = create_list(:enrolment, 2, table: tables2[1])

                enrolments1[0].deleted_at = Time.now
                enrolments1[0].save

                get coffee_shop_event_table_enrolments_url(coffee_shop, events[0], tables1[0]),
                headers: headers

                expect(json["data"].length).to eql(1)
            end

            it "shloud not see enrolment in deactivated event" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                events = create_list(:opened_event , 2, coffee_shop: coffee_shop)
                board_games = create_list(:board_game, 2, coffee_shop: coffee_shop)

                tables1 = board_games.map { |p| create :table, board_game: p, event: events[0] }
                tables2 = board_games.map { |p| create :table, board_game: p, event: events[1] }

                enrolments1 = create_list(:enrolment, 2, table: tables1[0])
                enrolments2 = create_list(:enrolment, 2, table: tables1[1])
                enrolments3 = create_list(:enrolment, 2, table: tables2[0])
                enrolments4 = create_list(:enrolment, 2, table: tables2[1])

                events[0].deleted_at = Time.now
                events[0].save

                get coffee_shop_event_table_enrolments_url(coffee_shop, events[0], tables1[0]),
                headers: headers

                expect(json["data"].length).to eql(0)
            end

            it "shloud not see enrolment in deactivated coffee_shop" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}

                coffee_shop = create :coffee_shop

                events = create_list(:opened_event , 2, coffee_shop: coffee_shop)
                board_games = create_list(:board_game, 2, coffee_shop: coffee_shop)

                tables1 = board_games.map { |p| create :table, board_game: p, event: events[0] }
                tables2 = board_games.map { |p| create :table, board_game: p, event: events[1] }

                enrolments1 = create_list(:enrolment, 2, table: tables1[0])
                enrolments2 = create_list(:enrolment, 2, table: tables1[1])
                enrolments3 = create_list(:enrolment, 2, table: tables2[0])
                enrolments4 = create_list(:enrolment, 2, table: tables2[1])

                coffee_shop.deleted_at = Time.now
                coffee_shop.save

                get coffee_shop_event_table_enrolments_url(coffee_shop, events[0], tables1[0]),
                headers: headers

                expect(json["data"].length).to eql(0)
            end
        end
    end

    describe ".create" do
        context "when loged in az player" do
            it "should create an enrolment on a table for loged in user" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                opened_table = create :opened_table
                count = Enrolment.count
                post coffee_shop_event_table_enrolments_url(opened_table.event.coffee_shop,opened_table.event, opened_table), params: {}, headers: headers
                newCount = Enrolment.count

                expect(newCount - count).to eq(1)
                expect(json["data"]["attributes"]["user"]["id"]).to eql(player.id)
                expect(json["data"]["attributes"]["table"]["id"]).to eql(opened_table.id)
            end
        end
    end

    describe ".destroy" do
        context "when loged in az player" do
            it "should destroy an enrolment on a table for loged in user" do
                player = create :player
                login player
                headers = {"Authorization": JSON.parse(response.body)["jwt"]}
                
                enrolment = create :enrolment, user: player

                delete coffee_shop_event_table_enrolment_url(enrolment.table.event.coffee_shop, enrolment.table.event, enrolment.table, enrolment), headers: headers

                expect(Enrolment.find(enrolment.id).active?).to eq(false)
                expect(json["data"]['id'].to_i).to eq(enrolment.id)
                expect(json["data"]["attributes"]["user"]["id"]).to eql(enrolment.user.id)
                expect(json["data"]["attributes"]["table"]["id"]).to eql(enrolment.table.id)
            end
        end
    end
end
