<template>
  <v-container >
    <v-row class="text-center" align="center" justify="center">
        <vault-interface :vaultTitle='"Supply"'/>
        <bonus-infos/>
        <vault-interface :vaultTitle='"Borrow"'/>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios'
import BonusInfos from '../components/BonusInfos.vue'
import VaultInterface from '../components/VaultInterface.vue'

  export default {
    name: 'Vaults',
    components: {
      BonusInfos,
      VaultInterface
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
