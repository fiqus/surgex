<template>
   <div class="card form-login bg-light">
    <article class="card-body">
      <h1 class="text-center">Servicio de Cirugía Plástica</h1>
      <hr>
      <h3 class="text-center" v-if="user">{{ formatFullName(user) }}<br/><small>{{ user.email }}</small></h3>
      <button class="btn btn-primary btn-block btn-sm shadow" v-if="!user" v-on:click="redirectLogin">Iniciar Sesión</button>
    </article>
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
