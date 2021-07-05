<template>
  <v-card
    elevation="15"
    style="max-width:420px;border-radius: 20px;
    padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
    opacity: 0.95;"
    class="lime lighten-5"
  >
    <v-cols>
      <v-img
        alt="EtherScore Logo"
        contain
        :src="require('@/assets/etherscore_black_transparent.png')"
        transition="scale-transition"
        height="100" 
      />
      <v-spacer/>
      <span class="text-h4 font-weight-light black--text" >
        EtherScore <br/>
        Leaderboard
      </span>
      </v-cols>
      <p class="text-subtitle-1 font-weight-thin black--text" align="left">
        Check your rank over all badges holders
      </p>
      <v-text-field
        v-model="search"
        append-icon="mdi-magnify"
        label="Enter address to check user rank"
        single-line
      ></v-text-field>
      <v-data-table
        :headers="headers"
        :items="leaders"
        :items-per-page="5"
        class="elevation-3 background"
        align='center'
        justify='center'
        dense
        :search="search"
      >

      <template
        v-for="header in headers.filter((header) =>
          header.hasOwnProperty('formatter')
        )"
        v-slot:[`item.${header.value}`]="{value}"
      >
        {{ header.formatter(value) }}
      </template>
      </v-data-table>
      <v-spacer/>
      <p class="text-subtitle-1 font-weight-thin black--text mt-10" align="left">
        Check the rank of badge model deployers
      </p>
      <v-text-field
        v-model="search"
        append-icon="mdi-magnify"
        label="Enter address to check deployer rank"
        single-line
      ></v-text-field>
      <v-data-table
        :headers="headers2"
        :items="leaders2"
        :items-per-page="5"
        class="elevation-3 background"
        align='center'
        justify='center'
        dense
        :search="search"
      >
      <template
        v-for="header in headers2.filter((header) =>
          header.hasOwnProperty('formatter')
        )"
        v-slot:[`item.${header.value}`]="{value}"
      >
        {{ header.formatter(value) }}
      </template>
      </v-data-table>
  </v-card>
</template>

<script>
  export default {
    name: 'Leaderboard',
    props: {
      vaultTitle: String
    },
    data () {
      return {
        search: '',
        headers: [
          { text: 'Rank', value: 'rank', filterable: false},
          { text: 'Address', value: 'address',
            formatter: value => value.substring(0, 3) + "..." + value.substring(39)},
          { text: 'Badges', value: 'badges', filterable: false},
        ],
        leaders: [
          {
            rank: '1',
            address: '0xd465be4e63bd09392bac51fcf04aa13412b552d0',
            badges: '4 / 11',
          },
          {
            rank: '2',
            address: '0xd465be4e63bd09392bac51fcf04aa13412b552n4',
            badges: '3 / 11',
          },{
            rank: '3',
            address: '0xd465be4e63bd09392bac51fcf04aa13412b552a7',
            badges: '2 / 11',
          },{
            rank: '4',
            address: '',
            badges: '-',
          },{
            rank: '5',
            address: '',
            badges: '-',
          },
        ],
        headers2: [
          { text: 'Rank', value: 'rank', filterable: false},
          { text: 'Address', value: 'address',
            formatter: value => value.substring(0, 3) + "..." + value.substring(39)},
          { text: 'Badges Models', value: 'badges', filterable: false},
          { text: 'Users minting', value: 'minting', filterable: false},
        ],
        leaders2: [
          {
            rank: '1',
            address: '0xd465be4e63bd09392bac51fcf04aa13412b552d0',
            badges: '6',
            minting: '4', 
          },
          {
            rank: '2',
            address: '0xd465be4e63bd09392bac51fcf04aa13412b552d2',
            badges: '4',
            minting: '3', 
          },{
            rank: '3',
            address: '0xd465be4e63bd09392bac51fcf04aa13412b552d8',
            badges: '1',
            minting: '2', 
          },{
            rank: '4',
            address: '',
            badges: '-',
            minting: '-', 
          },{
            rank: '5',
            address: '',
            badges: '-',
            minting: '-', 
          },
        ]
      }
    },
  }
</script>

<style lang="scss">
  .v-slider__track-container{
    height: 10px !important;
  }
</style>