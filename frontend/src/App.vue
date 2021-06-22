<template>
  <v-app id="main" :style="{background: $vuetify.theme.themes[theme].background}">
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
  },
  computed:{
    theme(){
      return (this.$vuetify.theme.dark) ? 'dark' : 'light'
    }
  }
};
</script>
