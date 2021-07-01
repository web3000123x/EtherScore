<template>
  <v-container >
    <v-row class="text-center">
        <v-card
          elevation="15"
          style="min-width:1200px; min-height:450px; border-radius: 20px;
           padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
           opacity: 0.95;"
          class="pa-10 mt-15"
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
                style="margin: 10px ;margin-top:20px; max-width:350px; border-radius: 20px;
                padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
                opacity: 0.95;"
                color="background"
                align="center"
                justify='center'
              >
              <v-spacer />
                <v-chip
                  class="text-h5 font-weight-light black mb-5"
                  outlined
                >
                  {{ nft.name }}
                </v-chip>
                <v-spacer />
                <v-avatar
                  width=120px
                  height=120px>
                <v-img
                  :src="nft.image_url"
                />
                </v-avatar>

                <v-spacer />
                <v-spacer/>
                  <p 
                    align="center"
                    justify="center"
                    class="black--text mt-3" 
                  > 
                    {{ nft.description }}
                  </p>
                <v-spacer/>
                <br/>
                <span class="black--text"> Conditions: </span>

                <v-list-item
                  v-for="condition in nft.conditions"
                  :key="condition.description"
                  class="ma-0 pa-0"
                >
                  <v-list-item-content align="left">
                    <v-list-item-title v-text="nft.issuer"></v-list-item-title>
                    <v-list-item-subtitle 
                      v-text="condition.description + ' ' + condition.operator + ' ' + condition.target"
                    >
                    </v-list-item-subtitle>
                    <v-progress-linear
                      :value="getExperienceValue(condition)"
                      v-if="address !== ''"
                      height="20"
                    > 
                      <span v-if="getExperienceValue(condition) !== 100 && condition.target !== 0"> 
                        {{ "You: " + Math.round(nft.conditions[0].current) + " / " + nft.conditions[0].target }} 
                      </span>
                      <span v-else-if="getExperienceValue(condition) !== 100 && condition.target == 0"> 
                        {{ "You: " + Math.round(nft.conditions[0].current) }} 
                      </span>
                      <span v-else> Condition validated ! </span>
                    </v-progress-linear>
                  </v-list-item-content>

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
                            v-if="getExperienceValue(condition) !== 100"
                            color="secondary"
                            v-bind="attrs"
                            v-on="on"
                          >
                            mdi-checkbox-blank-outline
                          </v-icon>
                          <v-icon
                            v-else
                            color="green"
                            v-bind="attrs"
                            v-on="on"
                          >
                            mdi-checkbox-marked-outline
                          </v-icon>
                        </template>
                      </v-tooltip>

                  </v-list-item-action>
                </v-list-item>

                <v-card-actions>
                <badge-dialog-detail :nft="nft" class="rounded-xl ma-2"/>
                <v-btn
                  color="secondary"
                  class="rounded-xl ma-3 ml-12"
                  :disabled="!isClaimable(nft)"
                  v-on:click="fakeMetamaskPrompt"
                >
                  <span v-if="!isClaimable(nft)"> Not Claimable </span>
                  <span v-else> Claim </span>
                </v-btn>
                </v-card-actions>
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
      getExperienceValue(condition){
        if (condition !== undefined) {
          if (condition.operator == ">") {
            if (condition.target == 0 && condition.current > 0) {
              return 100
            }
            if (condition.target == 0 && condition.current == 0) {
              return 0
            }
            return (100 * condition.current/condition.target)
          }
          if (condition.operator == "==") {
            if (condition.target == condition.current) {
              return 100
            }
          }
          return 0
        }
      },
      fakeMetamaskPrompt(){
        alert('This is a fake metamask prompt')
      },
      isClaimable(nft){
        for (var condition in nft.conditions) {
          if (this.getExperienceValue(condition) !== 100) {
            return false
          }
        }
        return true
      }
  }
  }
</script>
