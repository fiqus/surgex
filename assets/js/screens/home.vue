<template>
  <div class="center form-login">
    <h1>Registro de Cirugía</h1>
    <h3>Servicio de Cirugía Plástica</h3>
    <button v-on:click="redirectLogin">Iniciar Sesión</button>
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

    },
    methods: {
      redirectLogin: function() {
        window.location = "/#/login"
      }
    }
  }
</script>
