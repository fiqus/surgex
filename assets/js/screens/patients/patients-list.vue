<template>
  <div class="m-3" id="patients-list">
    <h3>Listado de Pacientes</h3>
    <hr>
    <button class="btn btn-primary float-right mb-3" v-on:click="showNew">
      <i class="fa fa-plus"></i>
      Agregar Paciente
    </button>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <customTable 
        v-if="patients.length"
        :headers="headers"
        :data="patients"
        @onClick="showDetail"
        @onEdit="showEdit"
        @onDelete="onDelete">
      </customTable>
      <h4 v-if="!patients.length">Aún no hay pacientes ingresados.</h4>
    </div>
  </div>
</template>

<script>
import customTable from "../../components/custom-table";
import {formatFullName} from "../../utils";
export default {
  components: {
    customTable
  },
  data() {
    return {
      headers: [
        {key: "full_name", value: "Paciente", parser: formatFullName},
        {key: "medical_history", value: "Historia Clínica"},
        {key: "social_id", value: "DNI"},
        {key: "phone", value: "Teléfono"}
      ],
      patients: [],
      loading: true
    }
  },
  created() {
    this.$store.dispatch("fetchPatients")
      .then((patients) => {
        this.patients = patients;
        this.loading = false;
      });
  },
  methods: {
    showNew() {
      this.$router.push({name: "patients-new"});
    },
    showDetail(patient) {
      this.$router.push({name: "patients-show", params: {patientId: patient.id}});
    },
    showEdit(patient) {
      this.$router.push({name: "patients-edit", params: {patientId: patient.id}});
    },
    onDelete: function(patient) {
      const onSuccess = () => {
        this.patients = this.patients.filter((p) => {
          return p.id !== patient.id;
        });
      };

      this.$store.dispatch("deletePatient", {component: this, patient, onSuccess})
    }
  }
}
</script>
