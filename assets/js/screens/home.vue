<template>
  <div class="center form-login">
    <h1>Servicio de Cirugía Plástica</h1>
    <h3 v-if="userAuth">{{ userAuth.lastName }}, {{ userAuth.firstName }}<br/><small>{{ userAuth.email }}</small></h3>
    <button v-if="!userAuth" v-on:click="redirectLogin">Iniciar Sesión</button>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        message: ""
      }
    },
    computed: {
      userAuth: {
        get() {
          return this.$store.state.authUser;
        }
      }
    },
    methods: {
      redirectLogin: function() {
        this.$router.push({name: "login"});
      }
    }
  }
</script>
