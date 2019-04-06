<template>
  <div id="users-form">
    <h3 class="subtitle" v-if="loading">Cargando...</h3>
    <div v-if="!loading">
      <h3 class="subtitle">Editar usuario: {{ formatFullName(user) }}</h3>
      <customForm
        :fields="fields"
        :data="user"
        @onSubmit="submit">
      </customForm>
    </div>
  </div>
</template>
<script>
import customForm from "../../components/custom-form";
import {formatFullName} from "../../utils";
export default {
  components: {
		customForm
	},
  data() {
    return {
      user: {},
      loading: true,
      fields: [
        {key: "email", label: "Email", disabled: true},
        {key: "is_admin", label: "Es administrador", type: "checkbox"},
        {key: "disabled", label: "Acceso desactivado", type: "checkbox"}
      ],
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
    submit: function () {
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch("updateUser", {component: this, user: this.user, onSuccess});
    }
	}
}
</script>
