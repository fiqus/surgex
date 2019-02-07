<template>
  <div>
    <h3 class="subtitle">Listado de Pacientes</h3>
    <button class="button">
      <i class="fa fa-plus"></i>
      Agregar Paciente
    </button>
    <customTable 
      v-if="this.patients"
      :headers="this.headers"
      :data="this.patients">
    </customTable>
    <h4 v-if="!this.patients">Aún no tiene Pacientes cargados</h4>
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
        {key: "first_name", value: "Nombre"}, 
        {key: "last_name", value: "Apellido"}, 
        {key: "city", value: "Ciudad"},
        {key: "address", value: "Dirección"}
      ],
      patients: null
    }
  },
  created() {
    this.$store.dispatch("fetchPatients")
      .then((patients) => {
        if(patients.length) {
          this.patients = patients;
        }
      });
  },
  computed: {
  }
}
</script>
