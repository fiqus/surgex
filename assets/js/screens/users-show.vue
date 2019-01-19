<template>
  <div v-if="!loading">
    <h3>Detalle de usuario</h3>
    <section class="elem-details">
      <div><b>Email:</b> {{user.email}}</div>
      <div><b>Admin:</b> {{ user.is_admin ? "S" : "N" }}</div>
      <div><b>Activo:</b> {{ user.disabled ? "N" : "S" }}</div>
    </section>
    <div>
      <a :href="`/#/users`">Volver</a>
      |
      <a :href="`/#/users/edit/${user.id}`">Editar</a>
      |
      <a :href="`/#/users/delete/${user.id}`">Eliminar</a>
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
      })
  }
}
</script>
