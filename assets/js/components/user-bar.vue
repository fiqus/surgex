<template>
  <div v-if="token" class="user-bar">
    <div class="logo-home">
      <a href="#/home"><img src="/images/logo-home.png"></a>
    </div>
    <div class="left">
      <p>{{user.firstName}} {{user.lastName}}</p>
    </div>
    <div class="right">
      <button v-if="!token" v-on:click="redirect('login')">Iniciar Sesión</button>
      <button v-if="token" v-on:click="redirect('surgeries')">Cirugías</button>
      <button v-if="token" v-on:click="redirect('patients-list')">Pacientes</button>
      <button v-if="token" v-on:click="redirect('surgeons-list')">Cirujanos</button>
      <button v-if="isAdmin" v-on:click="redirect('users-list')">Usuarios</button>
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
    isAdmin: {
      get() {
        return this.$store.getters.isAdmin;
      }
    },
    user: {
      get() {
        return this.$store.getters.getUser;
      }
    },
    token: {
      get() {
        return this.$store.getters.getToken;
      }
    }
  },
  methods: {
    redirect: function(screen) {
      if (screen !== "logout") {
        this.$router.push({name: screen});
      } else {
        this.$store.dispatch("logout");
      }
    }
  }
}
</script>
