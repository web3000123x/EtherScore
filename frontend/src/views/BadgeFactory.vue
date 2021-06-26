<template>
  <v-container >
    <v-row class="text-center" align="center" justify="center">
        <v-card
          elevation="15"
          style="margin:10px; max-width:350px; min-height:450px; border-radius: 20px;
           padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
           opacity: 0.95;"
          class="pa-10"
        >
          
          <h1 class="display-2 black--text">
            Badges Definitions
          </h1>
          <p class="subheading font-weight-regular black--text ma-2">
            List of badge models owned
          </p>
          <v-spacer></v-spacer>
          <metamask-chip/>
          
          


          

          <v-spacer></v-spacer>
          <!-- <v-btn
            color="secondary"
            class="ma-1 white--text rounded-xl  "
            align="center"
            justify="space-around"
            v-on:click="getTodos()"
            v-if="this.$store.state.address !== ''"
            
          >
            <span> Scan address</span>
          </v-btn> -->

          <v-row
            align="center"
            justify="center"
          >
           <template
              v-for="nft in this.todos"
              justify="center"
            >
              <v-card
                :key="nft.id"
                class="mx-primary"
                elevation="5"
                style="margin: 10px ;margin-top:20px; max-width:200px; border-radius: 20px;
                padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
                opacity: 0.95;"
                color="background"
                align="center"
                justify='center'
              >
              <v-spacer />
                <v-chip
                  class="text-subtitle-1 font-weight-light black"
                  style="margin: 5px"
                  outlined
                >
                  {{ nft.name }}
                </v-chip>
                <v-spacer />
                <v-img
                  :src="nft.image_url"
                  width=100px
                  style="padding-top: 5px"
                  class="mx-auto"
                />
                <p 
                  align="center"
                  justify="center"
                  class="black--text ml-n6 pa-0" 
                  style="width: 200px;"
                > 
                  {{ nft.conditions[0].description }} <br/>
                    on {{ nft.conditions[0].protocol +" ("+ nft.conditions[0].target + ")" }}
                </p>
                <v-row>
                <badge-dialog-detail :nft="nft"/>
                <v-spacer />
                </v-row>
                <v-spacer />
              </v-card>
            </template>
            </v-row>
        </v-card>
    <badge-definition/>
      </v-row>
  </v-container>
</template>

<script>
import { mapState } from 'vuex';
import axios from 'axios'
import MetamaskChip from '../components/MetamaskChip.vue'
import BadgeDialogDetail from '../components/BadgeDialogDetail.vue'
import BadgeDefinition from '../components/BadgeDefinition'

  export default {
    name: 'BadgeFactory',
    components: {
      MetamaskChip,
      BadgeDialogDetail,
      BadgeDefinition,
    },
    computed: mapState(['address']),
    data () {
      return {
        info: null,
        todos: []
      }
    },
    created () {
      this.getTodos()
    },
    watch: {
      address() {
      this.getTodos()
    }},
    methods: {
      getTodos () {
        // if (this.$store.state.address !== '') {
          const path = process.env.VUE_APP_BASE_URL + 'badges-definition'
          axios.post(path, { wallet_address: this.$store.state.address })
            .then((res) => {
              this.todos = res.data
            })
            .catch((error) => {
              // eslint-disable-next-line
          console.error(error);
            })
      },
      getExperienceValue(nft){
        if (nft.conditions[0].rule === "null") {
          return 100
        }
        return (100 * nft.conditions[0].current/nft.conditions[0].target)
      },
      fakeMetamaskPrompt(){
        alert('This is a fake metamask prompt')
      }
  }
  }
</script>
