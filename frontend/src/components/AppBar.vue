    <template>
    <v-app-bar
      app
      color="background"
      flat
    >
      <div class="d-flex align-center">
        <v-img
          alt="EtherScore Logo"
          class="shrink mr-2"
          contain
          :src="require('@/assets/etherscore_black_transparent.png')"
          transition="scale-transition"
          width="40"
        />

        <h1> EtherScore </h1>
      </div>

      <v-spacer></v-spacer>
      <v-btn
        class="rounded-xl pa-5"
        min-width="0"
        text
        to="/"
      >
        Home
        <v-icon>mdi-home-circle</v-icon>
      </v-btn>

      <v-spacer></v-spacer>
      <v-btn
        class="rounded-xl pa-5"
        min-width="0"
        text
        to="/badge-factory"
      >
        Badge Factory
        <v-icon>mdi-factory</v-icon>
      </v-btn>

      <v-spacer></v-spacer>

      <v-btn
        class="rounded-xl pa-5"
        min-width="0"
        text
        to="/badges"
      >
        Badges
        <v-icon>mdi-decagram</v-icon>
      </v-btn>

      <v-spacer></v-spacer>

      <v-btn
        class="rounded-xl pa-5"
        min-width="0"
        text
        to="/community"
      >
        Community
        <v-icon>mdi-account-group</v-icon>
      </v-btn>

      <v-spacer></v-spacer>

      <v-btn
        class="rounded-xl pa-6"
        align="center"
        justify="space-around"
        v-on:click="connectionMetamask()"
      >
      <span v-if="this.$store.state.address === ''"> Connect Wallet</span>
      <span v-else> {{ this.$store.state.address }}</span>
      <v-tooltip
        v-if="this.$store.state.address !== ''"
        bottom
      >
        <template v-slot:activator="{ on, attrs }">
          <v-icon
            color="secondary"
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
</template>
<script>
  export default {
    name: 'AppBar',
    data: () => ({
      connectionAsked: false,
      msg: 'Copy Address',
    }),
    methods: {
        async copyAddress () {
          await navigator.clipboard.writeText(this.$store.state.address)
          this.msg = 'Copied'
        },
        async connectionMetamask () {
          if (this.connectionAsked === false) {
            this.connectionAsked = true
            var accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
            this.$store.commit('updateAddress',accounts[0])
          } else {
            this.copyAddress()
          }
        },
    }
  }
</script>