<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand">{{user.firstName}} {{user.lastName}}</a>

    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" v-if="token" v-on:click="redirect('surgeries-list')">Cirugías</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" v-if="token" v-on:click="redirect('patients-list')">Pacientes</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" v-if="token" v-on:click="redirect('surgeons-list')">Cirujanos</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" v-if="user.isAdmin" v-on:click="redirect('users-list')">Usuarios</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" v-if="token" v-on:click="redirect('logout')">Cerrar Sesión</a>
        </li>
      </ul>
    </div>
    <div class="left">
      <p>{{user.firstName}} {{user.lastName}}</p>
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
