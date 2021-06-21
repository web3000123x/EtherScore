<template>
  <v-app>
    <app-bar/>

    <v-main>
      <router-view/>
    </v-main>
    <app-footer/>
  </v-app>
</template>

<script>

import AppFooter from '@/components/AppFooter.vue'
import AppBar from '@/components/AppBar.vue'

export default {
  name: 'App',
  components: {
    AppFooter,
    AppBar
  }
};
</script>
