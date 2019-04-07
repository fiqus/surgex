<template>
  <div id="diagnostics-show">
    <h3 class="subtitle">Detalle del Diagnóstico</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <section class="elem-details">
        <div><b>Nombre:</b> {{diagnostic.name}}</div>
        <div><b>Descripción:</b> {{diagnostic.description || "-"}}</div>
      </section>
      <div class="action-bar-buttons">
        <button class="btn btn-secondary" @click.stop="$router.go(-1)"><i class="fa fa-arrow-left"></i> Volver</button>
        <button class="btn btn-primary" @click.stop="showEdit(diagnostic)"><i class="fa fa-edit"></i> Editar</button>
        <button class="btn btn-danger" @click.stop="onDelete(diagnostic)"><i class="fa fa-trash"></i> Eliminar</button>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      diagnostic: null,
      loading: true
    }
  },
  created() {
    this.$store.dispatch("fetchDiagnostic", this.$route.params.diagnosticId)
      .then((diagnostic) => {
        this.diagnostic = diagnostic;
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
    showEdit(diagnostic) {
      this.$router.push({name: "diagnostics-edit", params: {diagnosticId: diagnostic.id}});
    },
    onDelete(diagnostic) {
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch("deleteDiagnostic", {component: this, diagnostic, onSuccess});
    }
  }
}
</script>
