<template>
  <v-container>
    <v-row class="text-center" align="center" justify="center" style="margin:50px">
        <bonus-infos/>
        <v-spacer/>
        <vault-interface :vaultTitle='"VIP Pool"'/>
        <v-spacer/>
        <v-col>
        <display-bonuses :bonusTitle='"IDOs"' :bonusDescription='"Join premium IDOs whitelist"' :bonusButtonLabel='"Join whitelist"' />
        <display-bonuses :bonusTitle='"Airdrops"' :bonusDescription='"Claim exclusive airdrops"' :bonusButtonLabel='"Claim airdrop"' />
        </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios'
import BonusInfos from '../components/BonusInfos.vue'
import VaultInterface from '../components/VaultInterface.vue'
import DisplayBonuses from '../components/DisplayBonuses.vue'

  export default {
    name: 'Bonus',
    components: {
      BonusInfos,
      VaultInterface,
      DisplayBonuses
    },
    data () {
      return {
        info: null
      }
    },
    mounted () {
      axios
        .get(process.env.VUE_APP_BASE_URL + 'ping')
        .then(response => (this.info = response.data))
    }
  }
</script>
