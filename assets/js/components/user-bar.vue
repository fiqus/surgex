<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a v-if="user" class="navbar-brand">{{user.first_name}} {{user.last_name}}</a>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" v-if="token" v-on:click="redirect('surgeries-list')">Cirugías</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" v-if="token" v-on:click="redirect('diagnostics-list')">Diagnósticos</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" v-if="token" v-on:click="redirect('patients-list')">Pacientes</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" v-if="token" v-on:click="redirect('surgeons-list')">Cirujanos</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" v-if="isAdmin" v-on:click="redirect('users-list')">Usuarios</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" v-if="token" v-on:click="redirect('logout')">Cerrar Sesión</a>
        </li>
      </ul>
    </div>
    <div v-if="user" class="left">
      <p>{{user.first_name}} {{user.last_name}}</p>
    </div>
  </nav>
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
