<template>
  <div class="center form-login">
    <h1>Registro de Cirugía</h1>
    <h3>Servicio de Cirugía Plástica</h3>
    <h3 v-if="userAuth">{{ userAuth.email }}</h3>
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
