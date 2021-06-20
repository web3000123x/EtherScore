<template>
  <v-footer padless>
    <v-col
      class="text-center"
      cols="12"
    >
      Copyright {{ new Date().getFullYear() }} — <strong>EtherScore</strong>
    </v-col>
  </v-footer>
</template>

<script>
  export default {
    name: 'AppFooter',
  }
</script>