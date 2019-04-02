<template>
  <div class="center form-login">
    <h1>Servicio de Cirugía Plástica</h1>
    <h3 v-if="user">{{ formatFullName(user) }}<br/><small>{{ user.email }}</small></h3>
    <button v-if="!user" v-on:click="redirectLogin">Iniciar Sesión</button>
  </div>
</template>

<script>
import {formatFullName} from "../utils";
export default {
  data() {
    return {
      message: "",
      formatFullName
    }
  },
  computed: {
    user: {
      get() {
        return this.$store.getters.getUser;
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
