<template>
<div v-if="!loading">
  <userBar/>
  <div id="app" class="container">
    <div id="main">
      <router-view></router-view>
    </div>
  </div>
</div>
</template>

<script>
import userBar from "./components/user-bar.vue"

export default {
  name: "App",
  components: {
    userBar
  },
  data() {
    return {
      loading: true
    }
  },
  created() {
    this.$store.dispatch("isAuth", this.$store.getters.getToken)
      .then(() => {
        this.loading = false;
      });
  }
}
</script>
