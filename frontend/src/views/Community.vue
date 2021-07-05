<template>
  <v-container>
    <v-row class="text-center" style="margin-top:50px">
        <challenge/>
        <v-spacer/>
        <leaderboard/>
        <v-spacer/>
        <v-col>
        <display-events
          :bonusTitle='"Partnered Offers"'
          :bonusDescription='"Exclusive events from our partners"'
          :currentOffers='"There is currently no active events"'
          :bonusButtonLabel='"Join newsletter"' 
        />
        </v-col>
    </v-row>
  </v-container>
</template>

<script>
import Challenge from '../components/Challenge.vue'
import DisplayEvents from '../components/DisplayEvents.vue'
import Leaderboard from '../components/Leaderboard.vue'

  export default {
    name: 'Community',
    components: {
      Challenge,
      DisplayEvents,
      Leaderboard,
    },
    data () {
      return {
        info: null
      }
    }
  }
</script>
