<template>
  <div id="users-show">
    <h3 class="subtitle">Detalle del Usuario</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <section class="elem-details">
        <div><b>Persona:</b> {{ formatFullName(user) }}</div>
        <div><b>Email:</b> {{user.email}}</div>
        <div><b>Última Sesión:</b> {{ formatDate(user.last_login) }}</div>
        <div><b>Es administrador:</b> {{ formatBoolean(user.is_admin) }}</div>
        <div><b>Acceso activado:</b> {{ formatBoolean(!user.disabled) }}</div>
      </section>
      <div class="action-bar-buttons">
        <button class="btn btn-secondary" @click.stop="$router.go(-1)"><i class="fa fa-arrow-left"></i> Volver</button>
        <button class="btn btn-primary" @click.stop="showEdit(user)" v-if="isAdmin"><i class="fa fa-edit"></i> Editar</button>
      </div>
    </div>
  </div>
</template>
<script>
import {formatDate, formatFullName, formatBoolean} from "../../utils";
export default {
  data() {
    return {
      user: null,
      loading: true,
      formatDate,
      formatFullName,
      formatBoolean
    }
  },
  created() {
    this.$store.dispatch("fetchUser", this.$route.params.userId)
      .then((user) => {
        this.user = user;
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
    showEdit(user) {
      this.$router.push({name: "users-edit", params: {userId: user.id}});
    }
  }
}
</script>
