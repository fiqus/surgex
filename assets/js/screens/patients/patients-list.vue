<template>
  <div>
    <h3 class="subtitle">Listado de Pacientes</h3>
    <customTable 
      v-if="this.patients"
      :headers="this.headers"
      :data="this.patients"
      @onClick="showDetail"
      @onEdit="showEdit"
      @onDelete="onDelete">
    </customTable>
    <button class="button" v-on:click="showNew">
      <i class="fa fa-plus"></i>
      Agregar Paciente
    </button>
    <h4 v-if="!this.patients.length">Aún no hay pacientes ingresados.</h4>
  </div>
</template>

<script>
import customTable from "../../components/custom-table";
export default {
  components: {
    customTable
  },
  created() {
    this.$store.dispatch("fetchPatients")
      .then((patients) => {
        this.patients = patients;
      });
  },
  data() {
    return {
      headers: [
        {key: "fullName", value: "Paciente", parser: (p) => `${p.lastName}, ${p.firstName}`},
        {key: "medicalHistory", value: "Historia Clínica"},
        {key: "city", value: "Ciudad"}
      ],
      patients: []
    }
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
      this.$router.push({name: "new-patient"});
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
