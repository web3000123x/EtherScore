<template>
  <v-card
    elevation="15"
    style="margin:0px; max-width:300px; min-height:450px; border-radius: 20px;
      padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
      opacity: 0.95;"
  >
    <v-row class="text-center" align="center" justify="center">
    
    <h1 class="display-2 black--text">
      Bonus
    </h1>
    <metamask-chip/>
    
    
    <p class="subheading font-weight-regular black--text">
      Bonus based on your NFT badges
    </p>

    <v-list-item
      v-for="badge in badges"
      :key="badge.title"
      class="ma-0 pa-0"
    >
      <v-list-item-avatar>
        <v-icon
          color="secondary"
          align="left"
          x-large
        >
          mdi-decagram
        </v-icon>
      </v-list-item-avatar>

      <v-list-item-content align="left">
        <v-list-item-title v-text="badge.title"></v-list-item-title>

        <v-list-item-subtitle 
          v-if="badge.title === 'Badge 0 - Compound'" 
          v-text="badge.subtitle"
          class="green--text"
        ></v-list-item-subtitle>
        <v-list-item-subtitle v-else v-text="badge.subtitle"></v-list-item-subtitle>
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
                v-if="badge.title === 'Badge 0 - Compound'"
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
            <span v-if="badge.title === 'Badge 0 - Compound'">You have this NFT</span>
            <span v-else>You do not have this NFT</span>
          </v-tooltip>

      </v-list-item-action>
    </v-list-item>
    </v-row>
    
  </v-card>
  
</template>

<script>
import MetamaskChip from '../components/MetamaskChip.vue'
  export default {
    name: 'BonusInfos',
    components: {
      MetamaskChip
    },
    data () {
      return {
        badges: [
        {
          subtitle: '5 % collateral covered',
          title: 'Badge 0 - Compound',
        },
        {
          subtitle: '5 % collateral covered',
          title: 'Badge 1 - Aave',
        },
        {
          subtitle: '10% discount on minting',
          title: 'Badge 3 - EtherScore',
        }]
      }
    },
  }
</script>