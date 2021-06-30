<template>
  <v-card
    elevation="15"
    style="max-height:220px; max-width:350px; border-radius: 20px;
    padding: 1.5rem;  border: 1px solid; font-weight: 500;
    opacity: 0.95;"
    class="pa-5 lime lighten-5 mb-2"
  >
    <h1 class="text-h3 black--text">
      {{ bonusTitle }}
    </h1>
    <br/>
    <p class="subheading font-weight-regular black--text mt-n3">
      {{ bonusDescription }}
    </p>

    <v-spacer></v-spacer>

    <v-row
      align="center"
      justify="center"
    >
        <v-card
          class="primary mb-10"
          elevation="5"
          style="min-width:270px; border-radius: 20px;
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