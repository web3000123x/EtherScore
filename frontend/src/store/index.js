import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    address: ''
  },
  mutations: {
    updateAddress (state, address) {
      state.address = address
    }
  },
  actions: {
  },
  modules: {
  }
})
