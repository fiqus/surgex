<template>
  <div id="users-list">
    <h3 class="subtitle">Listado de Usuarios</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <customTable 
        v-if="users.length"
        :params="params"
        :headers="headers"
        :data="users"
        @onClick="showDetail"
        @onEdit="showEdit">
      </customTable>
      <h4 v-if="!users.length">Aún no hay usuarios ingresados.</h4>
    </div>
  </div>
</template>
<script>
import customTable from "../../components/custom-table.vue";
import {formatDate, formatBoolean} from "../../utils";
export default {
  components: {
    customTable
  },
  data() {
    return {
      params: {hideDelete: true},
      headers: [
        {key: "lastName", value: "Persona", parser: (u) => `${u.lastName}, ${u.firstName}`}, 
        {key: "email", value: "Email"}, 
        {key: "lastLogin", value: "Última Sesión", parser: (p) => formatDate(p.lastLogin)}, 
        {key: "isAdmin", value: "Admin", parser: (p) => formatBoolean(p.isAdmin)}, 
        {key: "disabled", value: "Activo", parser: (p) => formatBoolean(p.disabled)}
      ],
      users: [],
      loading: true
    }
  },
  created() {
    this.params.hideActions = !this.isAdmin;
    this.$store.dispatch("fetchUsers")
      .then((users) => {
        this.users = users;
        this.loading = false;
      });
  },
  computed: {
    isAdmin: {
      get() {
        return this.$store.getters.isAdmin;
      }
    }
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
