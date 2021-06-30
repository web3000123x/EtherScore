<template>
  <v-footer 
    color="background"
    flat
    padless
    class="mt-10"
  >
    <v-col class="text-center" cols="12">
      Copyright  &copy; {{ new Date().getFullYear() }} —
      <img width="32px" class="px-1 mb-n1" src="../assets/etherscore_black_transparent.png">
      <strong>EtherScore</strong>
      <v-spacer/>
      <div class="py-2 text-right">
        Powered By 
        <img width="30px" class="px-1" src="https://cryptologos.cc/logos/ethereum-eth-logo.png?v=010">
        <img width="30px" class="px-1" src="https://cryptologos.cc/logos/the-graph-grt-logo.png?v=010">
      </div>
    </v-col>
  </v-footer>
</template>

<script>
  export default {
    name: 'AppFooter',
  }
</script>