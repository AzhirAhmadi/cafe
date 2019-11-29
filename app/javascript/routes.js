//General
import sing_in      from './components/authenticate/sing_in.vue'
//User
import user_create      from './components/users/create.vue'
import user_index       from './components/users/index.vue'
import user_update        from './components/users/update.vue'
import user_show        from './components/users/show.vue'
//CoffeeShop
import coffee_shop_create      from './components/coffee_shops/create.vue'
import coffee_shop_index       from './components/coffee_shops/index.vue'
import coffee_shop_update        from './components/coffee_shops/update.vue'
import coffee_shop_show        from './components/coffee_shops/show.vue'
//Event
import event_create      from './components/events/create.vue'
import event_index       from './components/events/index.vue'
import event_update        from './components/events/update.vue'
import event_show        from './components/events/show.vue'
//BoardGame
import board_game_create      from './components/board_games/create.vue'
import board_game_index       from './components/board_games/index.vue'
import board_game_update        from './components/board_games/update.vue'
import board_game_show        from './components/board_games/show.vue'
//Table
import table_create      from './components/tables/create.vue'
import table_index       from './components/tables/index.vue'
import table_update        from './components/tables/update.vue'
import table_show        from './components/tables/show.vue'

const routes = [
//Table
    {
        path: '/coffee_shops/:coffee_shop_id/events/:event_id/tables/:id/show',
        name: 'table_show',
        component:  table_show,
        props: true
    },
    {
        path: '/coffee_shops/:coffee_shop_id/events/:event_id/tables/:id/update',
        name: 'table_update',
        component:  table_update,
        props: true
    },
    {
        path: '/coffee_shops/:coffee_shop_id/events/:event_id/tables/index',
        name: 'table_index',
        component:  table_index,
        props: true
    },
    {
        path: '/coffee_shops/:coffee_shop_id/events/:event_id/tables/create',
        name: 'table_create',
        component:  table_create,
        props: true
    },
//Table end
//BoardGame
    {
        path: '/coffee_shops/:coffee_shop_id/board_games/:id/show',
        name: 'board_game_show',
        component:  board_game_show,
        props: true
    },
    {
        path: '/coffee_shops/:coffee_shop_id/board_games/:id/update',
        name: 'board_game_update',
        component:  board_game_update,
        props: true
    },
    {
        path: '/coffee_shops/:coffee_shop_id/board_games/index',
        name: 'board_game_index',
        component:  board_game_index,
        props: true
    },
    {
        path: '/coffee_shops/:coffee_shop_id/board_games/create',
        name: 'board_game_create',
        component:  board_game_create,
        props: true
    },
//BoardGame end
//Event
    {
        path: '/coffee_shops/:coffee_shop_id/events/:id/show',
        name: 'event_show',
        component:  event_show,
        props: true
    },
    {
        path: '/coffee_shops/:coffee_shop_id/events/:id/update',
        name: 'event_update',
        component:  event_update,
        props: true
    },
    {
        path: '/coffee_shops/:coffee_shop_id/events/index',
        name: 'event_index',
        component:  event_index,
        props: true
    },
    {
        path: '/coffee_shops/:coffee_shop_id/events/create',
        name: 'event_create',
        component:  event_create,
        props: true
    },
//Event end
//CoffeeShop
    {
        path: '/coffee_shops/:id/show',
        name: 'coffee_shop_show',
        component:  coffee_shop_show,
        props: true
    },
    {
        path: '/coffee_shops/:id/update',
        name: 'coffee_shop_update',
        component:  coffee_shop_update,
        props: true
    },
    {
        path: '/coffee_shops/index',
        name: 'coffee_shop_index',
        component:  coffee_shop_index,
        props: true
    },
    {
        path: '/coffee_shops/create',
        name: 'coffee_shop_create',
        component:  coffee_shop_create,
        props: true
    },
//CoffeeShop end
//User 
    {
        path: '/users/:id/show',
        name: 'user_show',
        component:  user_show,
        props: true
    },
    {
        path: '/users/:id/update',
        name: 'user_update',
        component:  user_update,
        props: true
    },
    {
        path: '/users/index',
        name: 'user_index',
        component:  user_index,
        props: true
    },
    {
        path: '/users/create',
        name: 'user_create',
        component:  user_create,
        props: true
    },
//User end
//General 
    {
        path: '/',
        name: 'root',
        component:  coffee_shop_index,
        props: true
    },
    {
        path: '/sing_in',
        name: 'sing_in',
        component:  sing_in,
        props: true
    }
//General end
];
export default routes;