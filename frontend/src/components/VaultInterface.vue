<template>
  <v-card
    elevation="15"
    style="max-height:460px; max-width:350px;border-radius: 20px;
    padding: 1.4rem;  border: 1px solid; color: white; font-weight: 500;
    opacity: 0.95;"
    class="lime lighten-5"
  >
    <v-card-title>
      <span class="text-h4 font-weight-light black--text">
        Curated Pools
      </span>
      <p class="text-subtitle-1 font-weight-thin black--text" align="left">
        Reserved to EtherScore badge holders
      </p>
    </v-card-title>

    <v-spacer></v-spacer>

    <v-row
      align="center"
      justify="center"
    >
        <v-card
          class="mx-primary"
          elevation="5"
          style="margin-top:20px; min-width:270px; border-radius: 20px;
          border: 1px solid; color: white; font-weight: 500;
          opacity: 0.95;"
          color="background"
        >
        <v-tabs
          v-model="tabSupply"
          background-color="secondary"
          fixed-tabs
          centered
          icons-and-text
        >
          <v-tabs-slider  class="v-tabs-slider-wrapper" style="height: 5px;"></v-tabs-slider>

          <v-tab href="#tab-1">
            Stake
            <v-icon>mdi-account-arrow-right</v-icon>
          </v-tab>

          <v-tab href="#tab-2">
            Unstake
            <v-icon>mdi-account-arrow-left</v-icon>
          </v-tab>
        </v-tabs>

        <v-tabs-items v-model="tabSupply" class="ma-1">
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

          <p class="black--text mb-1">{{ valueSubmitted.toFixed(2) }} ETH</p> 
          <v-slider
              v-model="valueSubmitted"
              color="secondary"
              track-color="grey lighten-1"
              hint="ETH value"
              step="tickStep"
              max="1" 
              min="0"
          >
        <template v-slot:prepend>
          <v-icon
            color="secondary"
            @click="decrement"
          >
            mdi-minus
          </v-icon>
        </template>

        <template v-slot:append>
          <v-icon
            color="secondary"
            @click="increment"
          >
            mdi-plus
          </v-icon>
        </template>
        </v-slider>

          <v-spacer />

          <v-btn
            color="secondary"
            class="rounded-xl mt-0 mb-5 pa-5"
            v-on:click="fakeMetamaskPrompt"
          >
            <span> Confirm </span>
          </v-btn>
          <v-spacer />
        </v-card>
      </v-row>
  </v-card>
</template>

<script>
  export default {
    name: 'VaultInterface',
    props: {
      vaultTitle: String
    },
    data () {
      return {
        valueSubmitted: 0,
        tabSupply: null,
        tabBorrow: null,
        tickStep: 0.05,
      }
    },

    methods: {
      decrement () {
        this.valueSubmitted = this.valueSubmitted - this.tickStep
      },
      increment () {
        this.valueSubmitted = this.valueSubmitted + this.tickStep
      },
      fakeMetamaskPrompt(){
        alert('This is a fake metamask prompt')
      }
    },
  }
</script>

<style lang="scss">
  .v-slider__track-container{
    height: 10px !important;
  }
</style>