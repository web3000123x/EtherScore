import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import Badges from '../views/Badges.vue'
import Community from '../views/Community.vue'
import BadgeFactory from '../views/BadgeFactory.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/badges',
    name: 'Badges',
    component: Badges
  },
  {
    path: '/community',
    name: 'Community',
    component: Community
  },
  {
    path: '/badge-factory',
    name: 'Badge Factory',
    component: BadgeFactory
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
