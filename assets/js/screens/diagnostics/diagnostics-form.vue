<template>
  <div id="diagnostics-form">
    <h3 class="subtitle" v-if="loading">Cargando...</h3>
    <div v-if="!loading">
      <h3 v-if="isNew" class="subtitle">Crear Diagnóstico</h3>
      <h3 v-if="!isNew" class="subtitle">Editar Diagnóstico: {{ diagnostic.name }}</h3>
      <customForm
        :fields="fields"
        :data="diagnostic"
        @onSubmit="submit">
      </customForm>
    </div>
  </div>
</template>
<script>
import customForm from "../../components/custom-form";
export default {
	components: {
		customForm
	},
  data() {
    return {
      diagnostic: {},
      loading: true,
      isNew: !Boolean(this.$route.params.diagnosticId),
      fields: [
        {key: "name", label: "Nombre"},
        {key: "description", label: "Descripción"}
      ]
    }
  },
  created() {
    if (this.isNew) {
      this.loading = false;
    } else {
      this.$store.dispatch("fetchDiagnostic", this.$route.params.diagnosticId)
        .then((diagnostic) => {
          this.diagnostic = diagnostic;
          this.loading = false;
        });
    }
  },
	methods: {
    submit: function () {
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch(this.isNew ? "createDiagnostic" : "updateDiagnostic", {component: this, diagnostic: this.diagnostic, onSuccess});
    }
	}
}
</script>
