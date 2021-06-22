<template>
  <v-container >
    <v-row class="text-center" align="center" justify="center">
        <v-card
          elevation="15"
          style="margin:50px; max-width:500px; min-height:450px; border-radius: 20px;
           padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
           opacity: 0.95;"
          class="pa-10 ml-0"
        >
          <h1 class="display-2 black--text">
            Supply
          </h1>

          <v-spacer></v-spacer>

          <v-row
            align="center"
            justify="center"
          >
              <v-card
                class="mx-primary"
                elevation="5"
                style="margin: 10px ;margin-top:20px; max-width:300px; border-radius: 20px;
                padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
                opacity: 0.95;"
                color="background"
              >
              <v-tabs
                v-model="tabSupply"
                background-color="secondary"
                fixed-tabs
                centered
                dark
                icons-and-text
              >
                <v-tabs-slider></v-tabs-slider>

                <v-tab href="#tab-1">
                  Stake
                  <v-icon>mdi-account-arrow-right</v-icon>
                </v-tab>

                <v-tab href="#tab-2">
                  Unstake
                  <v-icon>mdi-account-arrow-left</v-icon>
                </v-tab>
              </v-tabs>

              <v-tabs-items v-model="tabSupply">
                <v-tab-item
                  v-for="i in 3"
                  :key="i"
                  :value="'tab-' + i"
                >
                </v-tab-item>
              </v-tabs-items>
                <v-spacer />
                <!-- TODO: Next chips to replace with user ETH balance (or ETH staked) -->
                <v-chip
                  class="text-subtitle-1 font-weight-light black"
                  v-if="this.tabSupply === 'tab-1'"
                  style="margin: 5px"
                  outlined
                >
                  Available balance: 0 ETH
                </v-chip>
                <v-chip
                  class="text-subtitle-1 font-weight-light black"
                  v-else
                  style="margin: 5px"
                  outlined
                >
                  Staked: 0 ETH
                </v-chip>
                <v-spacer />
                <!-- TODO: Next slider max to replace with user ETH balance (or ETH staked) -->

                <p class="black--text">{{ valueSubmittedSupply }} ETH</p> 
                <v-slider
                    v-model="valueSubmittedSupply"
                    color="secondary"
                    hint="ETH value"
                    step="0.005"
                    max="1" 
                    min="0"
                ></v-slider>

                <v-spacer />

                <v-btn
                  color="secondary"
                  class="rounded-xl pa-5"
                  v-on:click="fakeMetamaskPrompt"
                >
                  <span> Confirm </span>
                </v-btn>
                <v-spacer />
              </v-card>
            </v-row>
        </v-card>

        <!-- BONUS -->
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
            Get access to advantages based on your NFT badges
          </p>

          <v-list-item
            v-for="folder in folders"
            :key="folder.title"
            class="ma-0 pa-0"
          >
            <v-list-item-avatar>
              <v-icon
                color="secondary"
                dark
                align="left"
                x-large
              >
                mdi-decagram
              </v-icon>
            </v-list-item-avatar>

            <v-list-item-content align="left">
              <v-list-item-title v-text="folder.title"></v-list-item-title>

              <v-list-item-subtitle v-text="folder.subtitle"></v-list-item-subtitle>
            </v-list-item-content>

            <v-list-item-action>
                <v-tooltip bottom>
                  <template v-slot:activator="{ on, attrs }">
                    <v-icon
                      v-if="folder.title === 'Badge 0 - Compound'"
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
                  <span v-if="folder.title === 'Badge 0 - Compound'">You have this NFT</span>
                  <span v-else>You do not have this NFT</span>
                </v-tooltip>

                <v-tooltip bottom>
                  <template v-slot:activator="{ on, attrs }">
                    <v-icon
                      color="grey lighten-1"
                      dark
                      v-bind="attrs"
                      v-on="on"
                    >
                      mdi-information
                    </v-icon>
                  </template>
                  <span>More informations</span>
                </v-tooltip>
            </v-list-item-action>
          </v-list-item>
          </v-row>
          
        </v-card>

        <!-- Borrow -->
        <v-card
          elevation="15"
          style="margin:50px; max-width:550px; min-height:450px; border-radius: 20px;
           padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
           opacity: 0.95;"
          class="pa-10 mr-0"
        >
          <h1 class="display-2 black--text">
            Borrow
          </h1>
          <v-spacer></v-spacer>

          <v-row
            align="center"
            justify="center"
          >
              <v-card
                class="mx-primary"
                elevation="5"
                style="margin: 10px ;margin-top:20px; max-width:300px; border-radius: 20px;
                padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
                opacity: 0.95;"
                color="background"
              >
              <v-tabs
                v-model="tabBorrow"
                background-color="secondary"
                fixed-tabs
                centered
                dark
                icons-and-text
              >
                <v-tabs-slider></v-tabs-slider>

                <v-tab href="#tab-1">
                  Stake
                  <v-icon>mdi-account-arrow-right</v-icon>
                </v-tab>

                <v-tab href="#tab-2">
                  Unstake
                  <v-icon>mdi-account-arrow-left</v-icon>
                </v-tab>
              </v-tabs>

              <v-tabs-items v-model="tabBorrow">
                <v-tab-item
                  v-for="i in 3"
                  :key="i"
                  :value="'tab-' + i"
                >
                </v-tab-item>
              </v-tabs-items>
                <v-spacer />
                <!-- TODO: Next chips to replace with user ETH balance (or ETH staked) -->
                <v-chip
                  class="text-subtitle-1 font-weight-light black"
                  v-if="this.tabBorrow === 'tab-1'"
                  style="margin: 5px"
                  outlined
                >
                  Available balance: 0 ETH
                </v-chip>
                <v-chip
                  class="text-subtitle-1 font-weight-light black"
                  v-else
                  style="margin: 5px"
                  outlined
                >
                  Staked: 0 ETH
                </v-chip>
                <v-spacer />
                <!-- TODO: Next slider max to replace with user ETH balance (or ETH staked) -->

                <p class="black--text">{{ valueSubmittedBorrow }} ETH</p> 
                <v-slider
                    v-model="valueSubmittedBorrow"
                    color="secondary"
                    hint="ETH value"
                    step="0.005"
                    max="1" 
                    min="0"
                ></v-slider>

                <v-spacer />
                <!-- TODO: Replace button action with the right contract interaction -->

                <v-btn
                  color="secondary"
                  class="rounded-xl pa-5"
                  v-on:click="fakeMetamaskPrompt"
                >
                  <span> Confirm </span>
                </v-btn>
                <v-spacer />
              </v-card>
            </v-row>
        </v-card>
      </v-row>
  </v-container>
</template>

<script>
import axios from 'axios'
import MetamaskChip from '../components/MetamaskChip.vue'

  export default {
    name: 'Vaults',
    components: {
      MetamaskChip
    },
    data () {
      return {
        info: null,
        valueSubmittedSupply: 0,
        valueSubmittedBorrow: 0,
        tabSupply: null,
        tabBorrow: null,
        folders: [
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
    mounted () {
      axios
        .get(process.env.VUE_APP_BASE_URL + 'ping')
        .then(response => (this.info = response.data))
    },
    methods: {
      fakeMetamaskPrompt(){
        alert('This is a fake metamask prompt')
      }
    }
  }
</script>
