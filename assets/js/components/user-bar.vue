<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    
    <a class="navbar-brand" href="#">Menú</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse">
      <ul class="navbar-nav mr-auto">
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
      <ul class="nav navbar-nav navbar-right" v-if="user">
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              {{user.first_name}} {{user.last_name}}
            </a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
              <a v-on:click="logout" class="dropdown-item" href="#">Cerrar Sesión</a>
            </div>
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
