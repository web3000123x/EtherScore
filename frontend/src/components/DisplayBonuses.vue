<template>
  <v-card
    elevation="25"
    style="min-width:250px; border-radius: 20px;
    padding: 1.5rem;  border: 1px solid; font-weight: 500;
    opacity: 0.95;"
    class="pa-5 lime lighten-5 mb-7 mt-n2"
  >
    <v-card-title>
      <span class="text-h4 font-weight-light black--text">
        {{ bonusTitle }}
      </span>
      <p class="text-subtitle-1 font-weight-thin black--text" align="left">
        {{ bonusDescription }}
      </p>
    </v-card-title>

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
          <v-spacer />
        </v-card>
      </v-row>
  </v-card>
</template>

<script>
  export default {
    name: 'DisplayBonuses',
    props: {
      bonusTitle: String,
      bonusDescription: String,
      bonusButtonLabel: String
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