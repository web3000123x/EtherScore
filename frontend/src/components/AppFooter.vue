<template>
  <v-footer padless>
    <v-col
      class="text-center"
      cols="12"
    >
      Copyright  &copy; {{ new Date().getFullYear() }} — 
      <img width="20px" src="../assets/etherscore_black_transparent.png">
      <strong>EtherScore</strong>
    </v-col>
  </v-footer>
</template>

<script>
  export default {
    name: 'AppFooter',
  }
</script>