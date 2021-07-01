import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import Badges from '../views/Badges.vue'
import Bonus from '../views/Bonus.vue'
import About from '../views/About.vue'
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
    path: '/bonus',
    name: 'Bonus',
    component: Bonus
  },
  {
    path: '/badge-factory',
    name: 'Badge Factory',
    component: BadgeFactory
  },
  {
    path: '/about',
    name: 'About',
    component: About
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
