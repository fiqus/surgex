<template>
  <div id="app" class="container">
    <div id="main">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
export default {
  name: "App",
  getUser: () => {
    try {
      return JSON.parse(localStorage.getItem("user"));
    } catch (err) {
      return null;
    }
  },
  setUser: (user) => {
    return localStorage.setItem("user", JSON.stringify(user));
  }
}
</script>
