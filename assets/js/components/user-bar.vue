<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div id="navbarNav" class="collapse navbar-collapse">
      <ul class="navbar-nav">
        <li class="nav-item">
          <router-link :to="{name: 'home'}" class="nav-link">Home</router-link>
        </li>
        <li class="nav-item" v-if="!user">
          <router-link :to="{name: 'login'}" class="nav-link">Iniciar Sesión</router-link>
        </li>
        <li class="nav-item" v-if="user">
          <router-link :to="{name: 'surgeries-list'}" class="nav-link">Cirugías</router-link>
        </li>
        <li class="nav-item" v-if="user">
          <router-link :to="{name: 'diagnostics-list'}" class="nav-link">Diagnósticos</router-link>
        </li>
        <li class="nav-item" v-if="user">
          <router-link :to="{name: 'patients-list'}" class="nav-link">Pacientes</router-link>
        </li>
        <li class="nav-item" v-if="user">
          <router-link :to="{name: 'surgeons-list'}" class="nav-link">Cirujanos</router-link>
        </li>
        <li class="nav-item" v-if="isAdmin">
          <router-link :to="{name: 'users-list'}" class="nav-link">Usuarios</router-link>
        </li>
      </ul>
    </div>
    <div id="navbarUser" class="nav-user" v-if="user">
      <ul class="navbar-nav">
        <li class="nav-item">
          <span class="nav-link username">{{user.first_name}} {{user.last_name}}</span>
        </li>
        <li class="nav-item">
          <a class="nav-link" v-on:click="logout">Cerrar Sesión</a>
        </li>
      </ul>
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
    }
  },
  methods: {
    logout() {
      this.$store.dispatch("logout");
    }
  }
}
</script>
