<template>
  <v-card
    elevation="15"
    style="max-width:350px; min-height:450px; border-radius: 20px;
      padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
      opacity: 0.95;"
    class="pa-5 lime lighten-5 mr-4"
  >

    <v-card-title>
      <span class="text-h4 font-weight-light black--text">
        Bonus
      </span>
      <p class="text-subtitle-1 font-weight-thin black--text" align="left">
        Bonus based on your NFT badges
      </p>
    </v-card-title>
    <metamask-chip/>
    <v-list-item
      v-for="badge in badges"
      :key="badge.description"
      class="ma-0 pa-0"
    >
      <v-list-item-avatar width="70px" height="70px">
         <img :src="badge.image_url">
      </v-list-item-avatar>

      <v-list-item-content align="left">
        <v-list-item-title v-text="badge.name"></v-list-item-title>

        <v-list-item-subtitle 
          v-if="badge.name === 'Ze Trader' && address" 
          v-text="badge.bonus"
          class="green--text"
        ></v-list-item-subtitle>
        <v-list-item-subtitle v-else v-text="badge.bonus"></v-list-item-subtitle>
      </v-list-item-content>
      

      <!-- TODO: The next v-if should request user's balance -->
      <v-list-item-action>
          <v-tooltip bottom>
            <template v-slot:activator="{ on, attrs }">
              <v-icon
                color="grey lighten-1"
                v-bind="attrs"
                v-on="on"
              >
                mdi-information
              </v-icon>
            </template>
            <span>More informations</span>
          </v-tooltip>
          <v-tooltip bottom>
            <template v-slot:activator="{ on, attrs }">
              <v-icon
                v-if="badge.name === 'Ze Trader' && address"
                color="green"
                v-bind="attrs"
                v-on="on"
              >
                mdi-checkbox-marked-outline
              </v-icon>
              <v-icon
                v-else
                color="secondary"
                v-bind="attrs"
                v-on="on"
              >
                mdi-checkbox-blank-outline
              </v-icon>
            </template>
            <span v-if="badge.title === 'Ze Trader' && address">You have this NFT</span>
            <span v-else>You do not have this NFT</span>
          </v-tooltip>

      </v-list-item-action>
    </v-list-item>
    
  </v-card>
  
</template>

<script>
import axios from 'axios'
import { mapState } from 'vuex';
import MetamaskChip from '../components/MetamaskChip.vue'
  export default {
    name: 'BonusInfos',
    components: {
      MetamaskChip
    },
    computed: mapState(['address']),
    data () {
      return {
        badges: this.getTodos()
      }
    },
    methods: {
      getTodos () {
        const path = process.env.VUE_APP_BASE_URL + 'badges'
        axios.post(path, { wallet_address: String(this.address) })
          .then((res) => {
            this.badges = res.data
          })
          .catch((error) => {
            // eslint-disable-next-line
            console.error(error);
          })
      }
    }
  }
</script>