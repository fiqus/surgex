<template>
  <div v-if="!loading">
    <h3 class="subtitle">Detalle de Usuario</h3>
    <section class="elem-details">
      <div><b>Persona:</b> {{ user.lastName }}, {{ user.firstName }}</div>
      <div><b>Email:</b> {{user.email}}</div>
      <div><b>Admin:</b> {{ user.isAdmin ? "S" : "N" }}</div>
      <div><b>Activo:</b> {{ user.disabled ? "N" : "S" }}</div>
    </section>
    <div>
      <a :href="`/#/users`">Volver</a>
      |
      <a :href="`/#/users/edit/${user.id}`">Editar</a>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      user: null,
      loading: true
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
    
  }
}
</script>
