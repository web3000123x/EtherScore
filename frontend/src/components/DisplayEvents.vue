<template>
  <v-card
    elevation="25"
    style="min-width:330px; max-width:330px; border-radius: 20px;
    padding: 1.2rem;  border: 1px solid; font-weight: 500;
    opacity: 0.95;"
    class="lime lighten-5 mt-n2"
  >            
  <v-cols>
      <v-img
        alt="EtherScore Logo"
        contain
        src="https://www.pikpng.com/pngl/b/201-2010129_customer-gift-sending-list-svg-png-icon-free.png"
        height="40" 
      />
    <v-card-title>

      <span class="text-h4 font-weight-light black--text">
        {{ bonusTitle }}
      </span>
      <p class="text-subtitle-1 font-weight-thin black--text" align="left">
        {{ bonusDescription }}
      </p>
    </v-card-title>
      </v-cols>

    <v-card-content>
      <v-list-item two-line>
        <v-list-item-content>
          <v-list-item-title class="text-subtitle-1 font-weight-thin black--text" align="left">Airdrops</v-list-item-title>
          <v-list-item-subtitle class="text-subtitle-2 font-weight-thin black--text" align="left">{{ currentOffers }}</v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
      <v-list-item two-line>
        <v-list-item-content>
          <v-list-item-title class="text-subtitle-1 font-weight-thin black--text" align="left">IDOs</v-list-item-title>
          <v-list-item-subtitle class="text-subtitle-2 font-weight-thin black--text" align="left">{{ currentOffers }}</v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
      <v-list-item two-line>
        <v-list-item-content>
          <v-list-item-title class="text-subtitle-1 font-weight-thin black--text" align="left">Discounts</v-list-item-title>
          <v-list-item-subtitle class="text-subtitle-2 font-weight-thin black--text" align="left">{{ currentOffers }}</v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
      <br/>
      <p class="text-subtitle-1 font-weight-thin font-italic black--text" align="left">
        Click <a>here</a> to lean how to use EtherScore to reward or be rewarded.
      </p>
      <br/>
      </v-card-content>

    <v-spacer></v-spacer>

    <v-row
      justify="center"
    >
        <v-card
          class="primary mb-1"
          elevation="5"
          style="border-radius: 20px;
          border: 1px solid; color: white; font-weight: 500;
          opacity: 0.95;"
          color="background"
        >
          <v-btn
            color="secondary"
            class="rounded-xl ma-5 pa-5"
            v-on:click="fakeMetamaskPrompt"
          >
            <span> {{ bonusButtonLabel }} </span>
          </v-btn>
          <v-spacer/>
        </v-card>
      </v-row>
  </v-card>
</template>

<script>
  export default {
    name: 'DisplayEvents',
    props: {
      bonusTitle: String,
      bonusDescription: String,
      bonusButtonLabel: String,
      currentOffers: String,
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