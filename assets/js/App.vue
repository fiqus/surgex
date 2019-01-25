<template>
<div>
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
  }
}
</script>
