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
        <img width="30px" height="30px" class="mr-1" src="https://cryptologos.cc/logos/ethereum-eth-logo.png?v=010">
        <img width="30px" height="30px" class="mr-1" src="https://cryptologos.cc/logos/the-graph-grt-logo.png?v=010">
        <img width="30px" height="30px" class="mr-1" src="https://s3-us-west-1.amazonaws.com/compliance-ico-af-us-west-1/production/token_profiles/logos/original/e95/9bd/80-/e959bd80-e08c-4083-a467-a3c18af86913-1618465679-a07840bd3fb5bd1bfd842bf425f7a6a9f83dbab0.png">
      </div>
    </v-col>
  </v-footer>
</template>

<script>
  export default {
    name: 'AppFooter',
  }
</script>