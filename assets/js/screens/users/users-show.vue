<template>
  <div v-if="!loading">
    <h3 class="subtitle">Detalle de Usuario</h3>
    <section class="elem-details">
      <div><b>Persona:</b> {{ user.lastName }}, {{ user.firstName }}</div>
      <div><b>Email:</b> {{user.email}}</div>
      <div><b>Admin:</b> {{ user.isAdmin ? "S" : "N" }}</div>
      <div><b>Activo:</b> {{ user.disabled ? "N" : "S" }}</div>
      <div><b>Última Sesión:</b> {{ formatDate(user.lastLogin) }}</div>
    </section>
    <div class="action-bar-buttons">
      <button v-on:click="$router.go(-1)">Volver</button>
      <button @click="showEdit(user)">Editar</button>
    </div>
  </div>
</template>
<script>
import {formatDate} from "../../utils";
export default {
  data() {
    return {
      user: null,
      loading: true,
      formatDate
    }
  },
  created() {
    this.$store.dispatch("fetchUser", this.$route.params.userId)
      .then((user) => {
        this.user = user;
        this.loading = false;
      });
  },
  methods: {
    showEdit(user) {
      this.$router.push({name: "users-edit", params: {userId: user.id}});
    }
  }
}
</script>
