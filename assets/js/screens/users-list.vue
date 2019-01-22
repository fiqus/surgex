<template>
  <div id="users-list" v-if="!loading">
    <h3 class="subtitle">Listado de Usuarios</h3>
    <div><a href="/#/users/new">Crear nuevo usuario</a></div>
    <table>
      <thead>
        <th>Email</th>
        <th>Admin</th>
        <th>Activo</th>
        <th>Acciones</th>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td><a :href="`/#/users/${user.id}`">{{ user.email }}</a></td>
          <td>{{ user.is_admin ? "S" : "N" }}</td>
          <td>{{ user.disabled ? "N" : "S" }}</td>
          <td>
            <a :href="`/#/users/edit/${user.id}`">Editar</a>
            |
            <a @click="onDelete(user)">Eliminar</a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
export default {
  data() {
    return {
      users: [],
      loading: true
    }
  },
  created() {
    this.$store.dispatch("fetchUsers")
      .then((users) => {
        this.users = users;
        this.loading = false;
      });
  },
  methods: {
    onDelete(user) {
      if (!confirm(`¿Eliminar al usuario ${user.email}?`)) {
        return false;
      }
      
      this.$store.dispatch("deleteUser", user.id)
        .then((rs) => {
          this.users = this.users.filter((u) => {
            return u.id !== user.id;
          });
        });
    }
  }
}
</script>
