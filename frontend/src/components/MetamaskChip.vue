<template>
  <div v-if="this.$store.state.address === ''">
    <v-chip
      color="red"
      class="text-subtitle-1 font-weight-light"
      outlined
      text-color="white"
    >
      Metamask not connected
    </v-chip>
  </div>
  <div v-else>
    <v-chip
      color="green"
      class="text-subtitle-1 font-weight-light"
      outlined
      text-color="white"
    >
      Metamask connected
    </v-chip>
  </div>
</template>

<script>
  export default {
    name: 'MetmamaskChip',
  }
</script>