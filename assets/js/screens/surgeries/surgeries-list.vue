<template>
  <div id="surgeries-list">
    <h3 class="subtitle">Listado de Cirugías</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <button class="btn btn-primary float-right" v-on:click="showNew">
        <i class="fa fa-plus"></i>
        Agregar Cirugía
      </button>
      <customTable 
        v-if="surgeries.length"
        :headers="headers"
        :data="surgeries"
        @onClick="showDetail"
        @onEdit="showEdit"
        @onDelete="onDelete">
      </customTable>
      <h4 v-if="!surgeries.length">Aún no hay cirugías ingresadas.</h4>
    </div>
  </div>
</template>

<script>
import customTable from "../../components/custom-table";
import {formatDate, formatFullName} from "../../utils";

function formatAssistants(assistants, limit) {
  return (assistants || []).map((a) => {
    const val = formatFullName(a);
    return val.length > limit ? `${value.substring(0, (limit - 3))}..` : val;
  }).join("</br>") || "-";
}

export default {
  components: {
    customTable
  },
  data() {
    return {
      headers: [
        {key: "date", value: "Fecha", parser: (s) => formatDate(s.date, {time: false})},
        {key: "surgeon", value: "Cirujano", parser: (s) => formatFullName(s.surgeon)},
        {key: "assistants", value: "Ayudantes", parser: (s) => formatAssistants(s.assistants, 25)},
        {key: "patient", value: "Paciente", parser: (s) => formatFullName(s.patient)},
        {key: "medical_history", value: "N° HC", parser: (s) => s.patient.medical_history},
        {key: "diagnostic", value: "Diagnóstico", parser: (s) => "--"}
      ],
      surgeries: [],
      loading: true
    }
  },
  created() {
    this.$store.dispatch("fetchSurgeries")
      .then((surgeries) => {
        this.surgeries = surgeries;
        this.loading = false;
      });
  },
  methods: {
    showNew() {
      this.$router.push({name: "surgeries-new"});
    },
    showDetail(surgery) {
      this.$router.push({name: "surgeries-show", params: {surgeryId: surgery.id}});
    },
    showEdit(surgery) {
      // this.$router.push({name: "surgeries-edit", params: {surgeryId: surgery.id}});
      this.$awn.warning("Próximamente!");
    },
    onDelete(surgery) {
      const onSuccess = () => {
        this.surgeries = this.surgeries.filter((s) => {
          return s.id !== surgery.id;
        });
      };

      this.$store.dispatch("deleteSurgery", {component: this, surgery, onSuccess});
    }
  }
}
</script>