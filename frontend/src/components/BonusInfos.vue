<template>
  <v-card
    elevation="15"
    style="max-width:350px; min-height:450px; border-radius: 20px;
      padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
      opacity: 0.95;"
    class="pa-5 lime lighten-5"
  >
    
    <h1 class="text-h3 black--text">
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
      <v-list-item-avatar width="70px" height="70px">
         <img align="left" class="px-1" :src="badge.logo">
      </v-list-item-avatar>

      <v-list-item-content align="left">
        <v-list-item-title v-text="badge.title"></v-list-item-title>

        <v-list-item-subtitle 
          v-if="badge.title === 'Ze Trader' && address" 
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
                v-if="badge.title === 'Ze Trader' && address"
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
        badges: [
        {
          subtitle: 'Airdrops',
          title: 'Ze Trader',
          logo: 'https://imgflip.com/s/meme/Money-Money.jpg', 
        },
        {
          subtitle: '5 % collateral covered',
          title: 'Ze Borrower',
          logo: 'https://i.pinimg.com/originals/33/e0/0b/33e00b57d15daaece29e29e9b475683f.png', 
        },
        {
          subtitle: 'IDOs whitelisting',
          title: 'Ze Shark',
          logo: 'https://media.istockphoto.com/photos/shark-swimming-towards-the-surface-with-mouth-open-picture-id1160436763?b=1&k=6&m=1160436763&s=170667a&w=0&h=Vb8G06Wln7t1oDzdtKLTWh0LkCRT4n4wo2GD6RiBoX4=', 
        }]
      }
    },
  }
</script>