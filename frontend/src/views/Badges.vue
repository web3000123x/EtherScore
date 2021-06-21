<template>
  <v-container >
    <v-row class="text-center" align="center" justify="center">
        <v-card
          elevation="25"
          color="secondary"
          style="margin-top:15px; max-width:450px; border-radius: 20px;
           padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
           opacity: 0.95;"
        >
          
          <h1 class="display-2 mb-3">
            <v-icon color="white">mdi-decagram</v-icon>
            Badges
            <v-icon color="white">mdi-decagram</v-icon>
          </h1>

          <p class="subheading font-weight-regular">
            This page will display the list of all existing badges 
            with a button claimable... 
          </p>

          <metamask-chip/>

          <p>
            Data request from backend : 
          </p>
          <v-spacer></v-spacer>
          <v-chip
            color="white"
            class="text-subtitle-1 font-weight-light"
            outlined
            text-color="white"
          >
            {{ info }}
          </v-chip>
        </v-card>
      </v-row>
  </v-container>
</template>

<script>
import axios from 'axios'
import MetamaskChip from '../components/MetamaskChip.vue'

  export default {
    name: 'Badges',
    components: {
      MetamaskChip
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
