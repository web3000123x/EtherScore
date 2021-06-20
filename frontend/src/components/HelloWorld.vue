<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <p>
      NFTs based on Ethereum transaction history
    </p>
    <h3>Data</h3>
    <ul>
      <li> {{ info }} </li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Home',
  props: {
    msg: String
  },
  data () {
    return {
      info: null
    }
  },
  mounted () {
    axios
      .get(process.env.VUE_APP_BASE_URL + 'ping')
      .then(response => (this.info = response.data))
  }
}
</script>

<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
