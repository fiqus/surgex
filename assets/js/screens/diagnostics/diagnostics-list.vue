<template>
  <div id="diagnostics-list">
    <h3 class="subtitle">Listado de Diagnósticos</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <button class="btn btn-primary float-right" v-on:click="showNew">
        <i class="fa fa-plus"></i>
        Agregar Diagnóstico
      </button>
      <customTable 
        v-if="diagnostics.length"
        :headers="headers"
        :data="diagnostics"
        @onClick="showDetail"
        @onEdit="showEdit"
        @onDelete="onDelete">
      </customTable>
      <h4 v-if="!diagnostics.length">Aún no hay diagnósticos ingresados.</h4>
    </div>
  </div>
</template>
<script>
import customTable from "../../components/custom-table";
export default {
  components: {
    customTable
  },
  data() {
    return {
      headers: [
        {key: "name", value: "Nombre"},
        {key: "description", value: "Descripción"}
      ],
      diagnostics: [],
      loading: true
    }
  },
  created() {
    this.$store.dispatch("fetchDiagnostics")
      .then((diagnostics) => {
        this.diagnostics = diagnostics;
        this.loading = false;
      });
  },
  methods: {
    showNew() {
      this.$router.push({name: "diagnostics-new"});
    },
    showDetail(diagnostic) {
      this.$router.push({name: "diagnostics-show", params: {diagnosticId: diagnostic.id}});
    },
    showEdit(diagnostic) {
      this.$router.push({name: "diagnostics-edit", params: {diagnosticId: diagnostic.id}});
    },
    onDelete(diagnostic) {
      const onSuccess = () => {
        this.diagnostics = this.diagnostics.filter((s) => {
          return s.id !== diagnostic.id;
        });
      };

      this.$store.dispatch("deleteDiagnostic", {component: this, diagnostic, onSuccess});
    }
  }
}
</script>
