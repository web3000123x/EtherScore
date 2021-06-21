<template>
  <v-container>
    <v-row class="text-center">

      <v-col class="mb-4">
        <h1 class="display-2 font-weight-bold mb-3">
          Badges
        </h1>

        <p class="subheading font-weight-regular">
          This page will display the list of all existing badges 
          with a button claimable... 
        </p>
        
        <p> Data request from backend : {{ info }} </p>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from 'axios'

  export default {
    name: 'Badges',
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
