<template>
  <div v-if="!loading">
    <form v-on:submit="submit">
      <h3 v-if="isNew" class="subtitle">Crear cirujano</h3>
      <h3 v-if="!isNew" class="subtitle">Editar cirujano: {{ surgeon.lastName }}, {{ surgeon.firstName }}</h3>

      <div class="form-user">
        <div>
          <label>Nombre:</label>
          <input type="text" v-model="surgeon.firstName">
        </div>
        <div>
          <label>Apellido:</label>
          <input type="text" v-model="surgeon.lastName">
        </div>
        <div>
          <label>Email:</label>
          <input type="text" v-model="surgeon.email">
        </div>
        <div>
          <label>Licencia:</label>
          <input type="text" v-model="surgeon.license">
        </div>
        <div class="action-bar-buttons">
          <button type="button" v-on:click="$router.go(-1)">Cancelar</button>
          <button type="submit">Guardar</button>
        </div>
      </div>
    </form>
  </div>
</template>
<script>
export default {
  data() {
    return {
      surgeon: {},
      loading: true,
      isNew: !Boolean(this.$route.params.surgeonId),
      action: "/api/surgeons"
    }
	},
  created() {
    if (this.isNew) {
      this.loading = false;
      this.action = `${this.action}/new`;
    } else {
      this.action = `${this.action}/edit/${this.$route.params.surgeonId}`;
      this.$store.dispatch("fetchSurgeon", this.$route.params.surgeonId)
        .then((surgeon) => {
          this.surgeon = surgeon;
          this.loading = false;
        });
    }
  },
	methods: {
    submit: function (event) {
      event.preventDefault();
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch(this.isNew ? "createSurgeon" : "updateSurgeon", {component: this, surgeon: this.surgeon, onSuccess});
    }
	}
}
</script>
