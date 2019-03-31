<template>
  <div id="users-list">
    <h3 class="subtitle">Listado de Usuarios</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <table v-if="users.length">
        <thead>
          <th>Persona</th>
          <th>Email</th>
          <th>Última Sesión</th>
          <th>Admin</th>
          <th>Activo</th>
          <th>Acciones</th>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id">
            <td><a @click="showDetail(user)">{{ user.lastName }}, {{ user.firstName }}</a></td>
            <td>{{ user.email }}</td>
            <td>{{ formatDate(user.lastLogin) }}</td>
            <td>{{ user.isAdmin ? "S" : "N" }}</td>
            <td>{{ user.disabled ? "N" : "S" }}</td>
            <td>
              <a @click="showEdit(user)">Editar</a>
            </td>
          </tr>
        </tbody>
      </table>
      <h4 v-if="!users.length">Aún no hay usuarios ingresados.</h4>
    </div>
  </div>
</template>
<script>
import customTable from "../../components/custom-table.vue";
import {formatDate} from "../../utils";
export default {
  components: {
    customTable
  },
  data() {
    return {
      headers: [
        {key: "lastName", value: "Persona"}, 
        {key: "email", value: "Email"}, 
        {key: "isAdmin", value: "Admin"}, 
        {key: "disabled", value: "Activo"}
      ],
      users: [],
      loading: true,
      formatDate
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
      this.$router.push({name: "users-show", params: {userId: user.id}});
    },
    showEdit(user) {
      this.$router.push({name: "users-edit", params: {userId: user.id}});
    }
  }
}
</script>
