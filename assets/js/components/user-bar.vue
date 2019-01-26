<template>
  <div v-if="token" class="user-bar">
    <div class="logo-home">
      <a href="#/home"><img src="/images/logo-home.png"></a>
    </div>
    <div class="left">
      <p>{{user.email}}</p>
    </div>
    <div class="right">
      <button v-if="!token" v-on:click="redirect('/login')">Iniciar Sesión</button>
      <button v-if="token" v-on:click="redirect('/surgeries')">Cirugías</button>
      <button v-if="token" v-on:click="redirect('/patients')">Pacientes</button>
      <button v-if="user.isAdmin" v-on:click="redirect('/users')">Usuarios</button>
      <button v-if="token" v-on:click="redirect('logout')">Cerrar Sesión</button>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
    }
  },
  computed: {
    user: {
      get() {
        return this.$store.state.authUser;
      }
    },
    token: {
      get() {
        return this.$store.state.token;
      }
    }
  },
  methods: {
    redirect: function(screen) {
      if (screen !== "logout") {
        return window.location = `#${screen}`;
      } else {
        localStorage.clear();
        return window.location.reload();
      }
    }
  }
}
</script>
