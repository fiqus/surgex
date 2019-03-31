<template>
  <div id="patients-list">
    <h3 class="subtitle">Listado de Pacientes</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <button class="button float-right" v-on:click="showNew">
        <i class="fa fa-plus"></i>
        Agregar Paciente
      </button>
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
export default {
  components: {
    customTable
  },
  data() {
    return {
      headers: [
        {key: "fullName", value: "Paciente", parser: (p) => `${p.lastName}, ${p.firstName}`},
        {key: "medicalHistory", value: "Historia Clínica"},
        {key: "socialId", value: "DNI"},
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
  computed: {
    isAdmin: {
      get() {
        return this.$store.getters.isAdmin;
      }
    }
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
