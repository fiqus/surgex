<template>
  <div id="users-form">
    <h3 class="subtitle" v-if="loading">Cargando...</h3>
    <div v-if="!loading">
      <h3 class="subtitle">Editar usuario: {{ formatFullName(user) }}</h3>
      <form action="/api/users/edit" method="post" v-on:submit="submit">
        <div class="form-user">
          <div>
            <label>Email:</label>
            <input type="text" disabled v-model="user.email">
          </div>
          <div>
            <label>Es administrador:</label>
            <input name="is_admin" type="checkbox" v-model="user.isAdmin">
          </div>
          <div>
            <label>Acceso desactivado:</label>
            <input name="disabled" type="checkbox" v-model="user.disabled">
          </div>
          <div class="action-bar-buttons">
            <button type="button" class="btn btn-secondary" @click.stop="$router.go(-1)"><i class="fa fa-arrow-left"></i> Cancelar</button>
            <button type="submit" class="btn btn-success"><i class="fa fa-save"></i> Guardar</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</template>
<script>
import {formatFullName} from "../../utils";
export default {
  data() {
    return {
      user: {},
      loading: true,
      formatFullName
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
    submit: function (event) {
      event.preventDefault();
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch("updateUser", {component: this, user: this.user, onSuccess});
    }
	}
}
</script>
