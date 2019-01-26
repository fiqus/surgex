<template>
  <div id="users-list" v-if="!loading">
    <h3 class="subtitle">Listado de Usuarios</h3>
    <table>
      <thead>
        <th>Persona</th>
        <th>Email</th>
        <th>Admin</th>
        <th>Activo</th>
        <th>Acciones</th>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td><a @click="showDetail(user)">{{ user.lastName }}, {{ user.firstName }}</a></td>
          <td>{{ user.email }}</td>
          <td>{{ user.isAdmin ? "S" : "N" }}</td>
          <td>{{ user.disabled ? "N" : "S" }}</td>
          <td>
            <a :href="`/#/users/edit/${user.id}`">Editar</a>
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
    showDetail(user) {
      this.$router.push({name: "users-show", params: {userId: user.id}})
    }
  }
}
</script>
