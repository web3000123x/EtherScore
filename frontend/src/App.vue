<template>
  <v-app>
    <v-app-bar
      app
      color="black"
      dark
    >
      <div class="d-flex align-center">
        <v-img
          alt="EtherScore Logo"
          class="shrink mr-2"
          contain
          :src="require('./assets/logo.svg')"
          transition="scale-transition"
          width="40"
        />

        <h1> EtherScore </h1>
      </div>

      <v-spacer></v-spacer>

      <v-btn
      color="secondary"
      class="ma-1 white--text"
      align="center"
      justify="space-around"
      v-on:click="connectionMetamask()"
      >
      <span v-if="metamaskAddress === ''"> Connect Wallet</span>
      <span v-else> {{ metamaskAddress }}</span>
      <v-tooltip
        v-if="metamaskConnected"
        bottom
      >
        <template v-slot:activator="{ on, attrs }">
          <v-icon
            color="white"
            v-bind="attrs"
            v-on="on"
            v-on:click="copyAddress"
          >
            mdi-content-copy
          </v-icon>
        </template>
        <span>{{ msg }}</span>
      </v-tooltip>
    </v-btn>
      
    </v-app-bar>

    <v-main>
      <router-view/>
    </v-main>
    <app-footer/>
  </v-app>
</template>

<script>

import AppFooter from '@/components/AppFooter.vue'

export default {
  name: 'App',
  components: {
    AppFooter
  },
  data: () => ({
    connectionAsked: false,
    metamaskConnected: false,
    metamaskAddress: '',
    msg: 'Copy Address',
  }),
  methods: {
      async copyAddress () {
        await navigator.clipboard.writeText(this.metamaskAddress)
        this.msg = 'Copied'
      },
      async connectionMetamask () {
        if (this.connectionAsked === false) {
          this.connectionAsked = true
          var accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
          this.metamaskConnected = true
          this.metamaskAddress = accounts[0]
        } else {
          this.copyAddress()
        }
      },
  }
};
</script>
