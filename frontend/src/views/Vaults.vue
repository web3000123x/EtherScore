<template>
  <v-container>
    <v-row class="text-center">

      <v-col class="mb-4">
        <h1 class="display-2 font-weight-bold mb-3">
          Vaults
        </h1>

        <p class="subheading font-weight-regular">
          This page will do the interface to interact with EtherScore smart contracts
        </p>
        
        <p> Data request from backend : {{ info }} </p>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios'

  export default {
    name: 'Vaults',
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
