<template>
  <v-container >
    <v-row class="text-center" align="center" justify="center">
        <v-card
          elevation="15"
          style="margin:50px; max-width:550px; min-height:450px; border-radius: 20px;
           padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
           opacity: 0.95;"
          class="pa-10"
        >
          <v-row>
          <h1 class="display-2 mt-n2 mb-8 mr-8 black--text">
            Badges
          </h1>
          <v-spacer></v-spacer>
          <metamask-chip/>
          </v-row>
          
          <p class="subheading font-weight-regular black--text">
            Check your stats & mint as much NFTs as possible
          </p>

          

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

                <v-spacer />
                <v-progress-linear
                  :value="getExperienceValue(nft)"
                  v-if="$store.state.address !== '' && nft.conditions !== undefined"
                  class = "mt-1"
                  height="20"
                > 
                  <span v-if="getExperienceValue(nft) !== 100"> {{ Math.round(nft.conditions[0].current) + " / " + nft.conditions[0].target }} </span>
                  <span v-else> 100% </span>
                </v-progress-linear>
                <v-spacer/>
                  <p 
                    align="center"
                    justify="center"
                    class="black--text ml-n6 pa-0 mb-0" 
                    style="width: 200px;"
                  > 
                    {{ nft.conditions[0].description }} <br/>
                     on {{ nft.conditions[0].protocol +" ("+ nft.conditions[0].target + ")" }}
                  </p>
                <v-spacer />

                <br/>
                <v-row>
                <badge-dialog-detail :nft="nft"/>
                <v-spacer />
                <v-btn
                  color="secondary"
                  class="rounded-xl"
                  v-on:click="fakeMetamaskPrompt"
                  v-if="getExperienceValue(nft) === 100 && $store.state.address"
                >
                  <span> Claim </span>
                </v-btn>
                </v-row>
                <v-spacer />
              </v-card>
            </template>
            </v-row>
        </v-card>
      </v-row>
  </v-container>
</template>

<script>
import { mapState } from 'vuex';
import axios from 'axios'
import MetamaskChip from '../components/MetamaskChip.vue'
import BadgeDialogDetail from '../components/BadgeDialogDetail.vue'

  export default {
    name: 'Badges',
    components: {
      MetamaskChip,
      BadgeDialogDetail
    },
    computed: mapState(['address']),
    data () {
      return {
        info: null,
        todos: [],
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
        const path = process.env.VUE_APP_BASE_URL + 'badges'
        axios.post(path, { wallet_address: String(this.address) })
          .then((res) => {
            this.todos = res.data
          })
          .catch((error) => {
            // eslint-disable-next-line
            console.error(error);
          })
      },
      getExperienceValue(nft){
        if (nft.conditions !== undefined) {
          return (100 * nft.conditions[0].current/nft.conditions[0].target)
        }
      },
      fakeMetamaskPrompt(){
        alert('This is a fake metamask prompt')
      }
  }
  }
</script>
