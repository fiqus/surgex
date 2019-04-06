<template>
  <div id="surgeons-form">
    <h3 class="subtitle" v-if="loading">Cargando...</h3>
    <div v-if="!loading">
      <h3 v-if="isNew" class="subtitle">Crear cirujano</h3>
      <h3 v-if="!isNew" class="subtitle">Editar cirujano: {{ formatFullName(surgeon) }}</h3>
      <form v-on:submit="submit">
        <div class="form-surgeon">
          <div>
            <label>Nombre:</label>
            <input type="text" v-model="surgeon.firstName">
          </div>
          <div>
            <label>Apellido:</label>
            <input type="text" v-model="surgeon.lastName">
          </div>
          <div>
            <label>DNI:</label>
            <input type="text" v-model="surgeon.socialId">
          </div>
          <div>
            <label>Licencia:</label>
            <input type="text" v-model="surgeon.license">
          </div>
          <div>
            <label>Email:</label>
            <input type="text" v-model="surgeon.email">
          </div>
          <div>
            <label>Teléfono:</label>
            <input type="text" v-model="surgeon.phone">
          </div>
          <div>
            <label>Fecha de Nacimiento:</label>
            <input type="date" v-model="surgeon.birthdate">
          </div>
          <div>
            <label>Nacionalidad:</label>
            <input type="text" v-model="surgeon.nationality">
          </div>
          <div>
            <label>Dirección:</label>
            <input type="text" v-model="surgeon.address">
          </div>
          <div>
            <label>Ciudad:</label>
            <input type="text" v-model="surgeon.city">
          </div>
          <div>
            <label>Provincia:</label>
            <input type="text" v-model="surgeon.province">
          </div>
          <div class="action-bar-buttons">
            <button type="button" class="btn btn-secondary" @click="$router.go(-1)"><i class="fa fa-arrow-left"></i> Cancelar</button>
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
      surgeon: {},
      loading: true,
      isNew: !Boolean(this.$route.params.surgeonId),
      action: "/api/surgeons",
      formatFullName
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
